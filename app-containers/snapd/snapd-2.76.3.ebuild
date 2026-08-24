# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools bash-completion-r1 flag-o-matic go-module linux-info readme.gentoo-r1 systemd tmpfiles xdg-utils

DESCRIPTION="Service and tools for management of snap packages"
HOMEPAGE="http://snapcraft.io/"

# Upstream's 2.76.3 vendor bundle predates its own go.mod bumps: go.mod
# requires go-tpm2 v1.16.2 / secboot v0.0.0-20260623..., while the shipped
# vendor/ tree still contains v1.15.0 / v0.0.0-20260410.... The snapd code
# calls secboot APIs added after the vendored snapshot (e.g.
# sb_preinstall.ErrorKindNoHardwareRootOfTrust, sb_tpm2.WithLockoutAuth*),
# so pinning go.mod back cannot work; instead ship the two refreshed module
# sources from the Go module proxy and swap them into vendor/ (see
# src_unpack). Their own dependencies are unchanged between versions.
GO_TPM2_PV="1.16.2"
SECBOOT_PV="0.0.0-20260623135244-457b03a16d19"

SRC_URI="https://github.com/snapcore/snapd/releases/download/${PV}/snapd_${PV}.vendor.tar.xz -> ${P}.tar.xz
	https://proxy.golang.org/github.com/canonical/go-tpm2/%40v/v${GO_TPM2_PV}.zip -> canonical-go-tpm2-${GO_TPM2_PV}.zip
	https://proxy.golang.org/github.com/snapcore/secboot/%40v/v${SECBOOT_PV}.zip -> snapcore-secboot-${SECBOOT_PV}.zip"
MY_PV=${PV}
KEYWORDS="~amd64"

LICENSE="GPL-3 Apache-2.0 BSD BSD-2 LGPL-3-with-linking-exception MIT"
SLOT="0"
IUSE="apparmor +forced-devmode gtk kde systemd"
REQUIRED_USE="!forced-devmode? ( apparmor ) systemd"

CONFIG_CHECK="~CGROUPS
		~CGROUP_DEVICE
		~CGROUP_FREEZER
		~NAMESPACES
		~SQUASHFS
		~SQUASHFS_ZLIB
		~SQUASHFS_LZO
		~SQUASHFS_XZ
		~BLK_DEV_LOOP
		~SECCOMP
		~SECCOMP_FILTER"

RDEPEND="
	sys-libs/libseccomp:=
	apparmor? (
		sec-policy/apparmor-profiles
		sys-apps/apparmor:=
	)
	dev-libs/glib
	virtual/libudev
	systemd? ( sys-apps/systemd )
	sys-libs/libcap:=
	sys-fs/squashfs-tools[lzma,lzo]"

DEPEND="${RDEPEND}"

BDEPEND="
	>=dev-lang/go-1.9
	app-arch/unzip
	dev-python/docutils
	sys-devel/gettext
	sys-fs/xfsprogs"

PDEPEND="sys-auth/polkit[gtk?,kde?]"

README_GENTOO_SUFFIX=""

pkg_setup() {
	if use apparmor; then
		CONFIG_CHECK+=" ~SECURITY_APPARMOR"
	fi
	linux-info_pkg_setup

	# Seems to have issues building with -O3, switch to -O2
	replace-flags -O3 -O2
}

src_unpack() {
	default

	# Refresh the two stale vendored modules so vendor/ matches go.mod
	# (see comment above SRC_URI for why this is needed).
	local staging="${T}/gomod-refresh"
	mkdir "${staging}" || die
	pushd "${staging}" >/dev/null || die
	unpack "canonical-go-tpm2-${GO_TPM2_PV}.zip"
	unpack "snapcore-secboot-${SECBOOT_PV}.zip"

	rm -rf "${S}/vendor/github.com/canonical/go-tpm2" \
		"${S}/vendor/github.com/snapcore/secboot" || die
	cp -a "github.com/canonical/go-tpm2@v${GO_TPM2_PV}" \
		"${S}/vendor/github.com/canonical/go-tpm2" || die
	cp -a "github.com/snapcore/secboot@v${SECBOOT_PV}" \
		"${S}/vendor/github.com/snapcore/secboot" || die
	popd >/dev/null || die

	sed -i \
		-e "s|# github.com/canonical/go-tpm2 v1.15.0|# github.com/canonical/go-tpm2 v${GO_TPM2_PV}|" \
		-e "s|# github.com/snapcore/secboot v0.0.0-20260410084611-3f8b98c2db70|# github.com/snapcore/secboot v${SECBOOT_PV}|" \
		"${S}/vendor/modules.txt" || die
}

src_prepare() {
	default
	# Update apparmor profile to allow libtinfow.so*
	sed -i 's/libtinfo/libtinfo{,w}/' \
		"cmd/snap-confine/snap-confine.apparmor.in" || die

	if ! use forced-devmode; then
		sed -e 's#return !apparmorFull#if !apparmorFull {\n\t\tpanic("USE=forced-devmode is disabled")\n\t}\n\treturn false#' \
			-i "sandbox/forcedevmode.go" || die
		grep -q 'panic("USE=forced-devmode is disabled")' "sandbox/forcedevmode.go" || die "failed to disable forced-devmode"
	fi

	sed -i 's:command -v git >/dev/null:false:' -i "mkversion.sh" || die

	./mkversion.sh "${PV}"
	pushd "cmd" >/dev/null || die
	eautoreconf
}

src_configure() {
	SNAPD_MAKEARGS=(
		"BINDIR=${EPREFIX}/usr/bin"
		"DBUSSERVICESDIR=${EPREFIX}/usr/share/dbus-1/services"
		"LIBEXECDIR=${EPREFIX}/usr/lib"
		"SNAP_MOUNT_DIR=${EPREFIX}/var/lib/snapd/snap"
		"SYSTEMDSYSTEMUNITDIR=$(systemd_get_systemunitdir)"
	)
	# CFLAGS may contain -flto=* (e.g. thin LTO). Handing those to cgo makes
	# every host object LLVM bitcode, which the external linker invoked by
	# the go tool (clang -> default ld, no LTO plugin) cannot read:
	# "file format not recognized". Upstream does not LTO either; drop it.
	filter-flags '-flto*'
	export CGO_ENABLED="1"
	export CGO_CFLAGS="${CFLAGS}"
	export CGO_CPPFLAGS="${CPPFLAGS}"
	export CGO_CXXFLAGS="${CXXFLAGS}"

	pushd "${S}/cmd" >/dev/null || die
	econf --libdir="${EPREFIX}/usr/lib" \
		--libexecdir="${EPREFIX}/usr/lib/snapd" \
		$(use_enable apparmor) \
		--enable-nvidia-biarch \
		--with-snap-mount-dir="${EPREFIX}/var/lib/snapd/snap"
}

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME
	export GOBIN="${S}/bin"

	local file
	for file in "${S}/po/"*.po; do
		msgfmt "${file}" -o "${file%.po}.mo" || die
	done

	emake -C "${S}/data" "${SNAPD_MAKEARGS[@]}"

	local -a flags=(-buildmode=pie -ldflags "-s -linkmode external -extldflags '${LDFLAGS}'" -trimpath)
	local -a staticflags=(-buildmode=pie -ldflags "-s -linkmode external -extldflags '${LDFLAGS} -static'" -trimpath)

	local cmd
	for cmd in snap snapd snapd-apparmor snap-bootstrap snap-failure snap-preseed snap-recovery-chooser snap-repair snap-seccomp; do
		go build ${GOFLAGS} -mod=vendor -o "${GOBIN}/${cmd}" "${flags[@]}" \
		    -v -x "github.com/snapcore/${PN}/cmd/${cmd}"
		[[ -e "${GOBIN}/${cmd}" ]] || die "failed to build ${cmd}"
	done
	for cmd in snapctl snap-exec snap-update-ns; do
		go build ${GOFLAGS} -mod=vendor -o "${GOBIN}/${cmd}" "${staticflags[@]}" \
		    -v -x "github.com/snapcore/${PN}/cmd/${cmd}"
		[[ -e "${GOBIN}/${cmd}" ]] || die "failed to build ${cmd}"
	done
}

src_install() {
	emake -C "${S}/data" install "${SNAPD_MAKEARGS[@]}" DESTDIR="${D}"
	emake -C "${S}/cmd" install "${SNAPD_MAKEARGS[@]}" DESTDIR="${D}"

	if use apparmor; then
		mv "${ED}/etc/apparmor.d/usr.lib.snapd.snap-confine"{,.real} || die
		keepdir /var/lib/snapd/apparmor/profiles
	fi
	keepdir /var/lib/snapd/{apparmor/snap-confine,cache,cookie,snap,void}
	fperms 700 /var/lib/snapd/{cache,cookie}

	dobin "${GOBIN}/"{snap,snapctl}
	ln "${ED}/usr/bin/snapctl" "${ED}/usr/lib/snapd/snapctl" || die

	exeinto /usr/lib/snapd
	doexe "${GOBIN}/"{snapd,snapd-apparmor,snap-bootstrap,snap-failure,snap-exec,snap-preseed,snap-recovery-chooser,snap-repair,snap-seccomp,snap-update-ns} \
		"${S}/"{cmd/snap-discard-ns/snap-discard-ns,cmd/snap-mgmt/snap-mgmt} \
		"${S}/data/completion/bash/"{complete.sh,etelpmoc.sh,}

	dobashcomp "${S}/data/completion/bash/snap"

	insinto /usr/share/zsh/site-functions
	doins "${S}/data/completion/zsh/_snap"

	insinto "/usr/share/polkit-1/actions"
	doins "${S}/data/polkit/io.snapcraft.snapd.policy"

	dodoc "${S}/packaging/ubuntu-16.04/changelog"
	domo "${S}/po/"*.mo

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	xdg_desktop_database_update
	tmpfiles_process snapd.conf

	cat "${EPREFIX}/usr/lib/snapd/snap-confine.caps" | setcap - "${EPREFIX}/usr/lib/snapd/snap-confine"
	cat "${EPREFIX}/usr/lib/snapd/snap-confine.caps" | setcap -v - "${EPREFIX}/usr/lib/snapd/snap-confine"

	if use apparmor && [[ -z ${ROOT} && -e /sys/kernel/security/apparmor/profiles &&
		$(wc -l < /sys/kernel/security/apparmor/profiles) -gt 0 ]]; then
		apparmor_parser -r "${EPREFIX}/etc/apparmor.d/usr.lib.snapd.snap-confine.real"
	fi
}

pkg_postrm() {
	xdg_desktop_database_update
}
