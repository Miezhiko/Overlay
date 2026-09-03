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

# Same story: go.mod also requires go-efilib v1.8.0 (shipped vendor/ has the
# stale v1.7.1-...) and a wholly new direct dependency, cilium/ebpf v0.9.1,
# that isn't vendored at all. Fetch both from the module proxy too (see
# src_unpack). The vendored coreos/go-systemd is dead weight left over from
# an old go.mod (no longer required, and nothing in snapd's own source
# imports it any more), so it is simply dropped rather than refreshed.
GO_EFILIB_PV="1.8.0"
CILIUM_EBPF_PV="0.9.1"

SRC_URI="https://github.com/snapcore/snapd/releases/download/${PV}/snapd_${PV}.vendor.tar.xz -> ${P}.tar.xz
	https://proxy.golang.org/github.com/canonical/go-tpm2/%40v/v${GO_TPM2_PV}.zip -> canonical-go-tpm2-${GO_TPM2_PV}.zip
	https://proxy.golang.org/github.com/snapcore/secboot/%40v/v${SECBOOT_PV}.zip -> snapcore-secboot-${SECBOOT_PV}.zip
	https://proxy.golang.org/github.com/canonical/go-efilib/%40v/v${GO_EFILIB_PV}.zip -> canonical-go-efilib-${GO_EFILIB_PV}.zip
	https://proxy.golang.org/github.com/cilium/ebpf/%40v/v${CILIUM_EBPF_PV}.zip -> cilium-ebpf-${CILIUM_EBPF_PV}.zip"
MY_PV=${PV}
KEYWORDS="~amd64"

# Unlike 2.76.3, the release tarball's own root directory is now
# "snapd_${PV}.vendor" with the actual source nested one level inside it
# (snapd_2.77.vendor/snapd-2.77/...), not "${P}" directly. Without this the
# default S was a nonexistent path, and the vendor-refresh cp -a below (into
# "${S}/vendor/...") died with "No such file or directory" trying to create
# a directory under a parent that was never unpacked.
S="${WORKDIR}/snapd_${PV}.vendor/${P}"

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
	unpack "canonical-go-efilib-${GO_EFILIB_PV}.zip"
	unpack "cilium-ebpf-${CILIUM_EBPF_PV}.zip"

	rm -rf "${S}/vendor/github.com/canonical/go-tpm2" \
		"${S}/vendor/github.com/snapcore/secboot" \
		"${S}/vendor/github.com/canonical/go-efilib" \
		"${S}/vendor/github.com/coreos/go-systemd" || die
	cp -a "github.com/canonical/go-tpm2@v${GO_TPM2_PV}" \
		"${S}/vendor/github.com/canonical/go-tpm2" || die
	cp -a "github.com/snapcore/secboot@v${SECBOOT_PV}" \
		"${S}/vendor/github.com/snapcore/secboot" || die
	cp -a "github.com/canonical/go-efilib@v${GO_EFILIB_PV}" \
		"${S}/vendor/github.com/canonical/go-efilib" || die
	mkdir -p "${S}/vendor/github.com/cilium" || die
	cp -a "github.com/cilium/ebpf@v${CILIUM_EBPF_PV}" \
		"${S}/vendor/github.com/cilium/ebpf" || die
	popd >/dev/null || die

	sed -i \
		-e "s|# github.com/canonical/go-tpm2 v1.15.0|# github.com/canonical/go-tpm2 v${GO_TPM2_PV}|" \
		-e "s|# github.com/snapcore/secboot v0.0.0-20260410084611-3f8b98c2db70|# github.com/snapcore/secboot v${SECBOOT_PV}|" \
		-e "s|# github.com/canonical/go-efilib v1.7.1-0.20260310185303-7166aa858b24|# github.com/canonical/go-efilib v${GO_EFILIB_PV}|" \
		"${S}/vendor/modules.txt" || die

	# Drop the dead coreos/go-systemd entry and replace it with the new
	# cilium/ebpf one, matching go.mod's current direct dependency set.
	python3 - "${S}/vendor/modules.txt" <<-EOF || die
		import sys
		path = sys.argv[1]
		with open(path) as f:
		    text = f.read()
		old = (
		    "# github.com/coreos/go-systemd v0.0.0-20191104093116-d3cd4ed1dbcf\n"
		    "## explicit\n"
		    "github.com/coreos/go-systemd/activation\n"
		)
		new = (
		    "# github.com/cilium/ebpf v${CILIUM_EBPF_PV}\n"
		    "## explicit; go 1.17\n"
		    "github.com/cilium/ebpf\n"
		    "github.com/cilium/ebpf/asm\n"
		    "github.com/cilium/ebpf/btf\n"
		    "github.com/cilium/ebpf/internal\n"
		    "github.com/cilium/ebpf/internal/sys\n"
		    "github.com/cilium/ebpf/internal/unix\n"
		)
		assert old in text, "coreos/go-systemd modules.txt block not found"
		with open(path, "w") as f:
		    f.write(text.replace(old, new))
	EOF
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

	# Unlike 2.76.3, "snap" is no longer a Go binary at all (cmd/snap was
	# removed upstream); the CLI entrypoint is now the small C
	# cmd/snap-cli-wrap program, which just execs the snapd binary itself
	# (see snap-cli-wrap.c). It's built by the autotools "cmd" tree (see
	# src_install) and installed separately below, not via go build here.
	local cmd
	for cmd in snapd snapd-apparmor snap-bootstrap snap-failure snap-preseed snap-recovery-chooser snap-repair snap-seccomp; do
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

	dobin "${GOBIN}/snapctl"
	# "snap" is the C snap-cli-wrap binary now, not a Go build; see
	# src_compile for why. It's a noinst_PROGRAM (built by the emake -C
	# cmd install above as part of "all", but not auto-installed), so
	# install it explicitly as /usr/bin/snap, matching upstream's own
	# packaging (see packaging/fedora/snapd.spec).
	newbin "${S}/cmd/snap-cli-wrap/snap-cli-wrap" snap
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
