# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"

inherit bash-completion-r1 flag-o-matic python-any-r1 toolchain-funcs xdg-utils

DESCRIPTION="A JavaScript runtime built on Chrome's V8 JavaScript engine"
HOMEPAGE="https://nodejs.org/"
LICENSE="Apache-1.1 Apache-2.0 BSD BSD-2 MIT"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/nodejs/node"
	SLOT="0"
else
	SRC_URI="https://nodejs.org/dist/v${PV}/node-v${PV}.tar.xz"
	SLOT="0/$(ver_cut 1)"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x64-macos"
	S="${WORKDIR}/node-v${PV}"
fi

IUSE="cpu_flags_x86_sse2 debug doc +icu inspector lto +npm +snapshot +ssl +system-icu +system-ssl systemtap test"
REQUIRED_USE="inspector? ( icu ssl )
	npm? ( ssl )
	system-icu? ( icu )
	system-ssl? ( ssl )"

RESTRICT="!test? ( test )"

RDEPEND=">=app-arch/brotli-1.0.9:=
	>=dev-libs/libuv-1.40.0:=
	>=net-dns/c-ares-1.17.2:=
	>=net-libs/nghttp2-1.41.0:=
	sys-libs/zlib
	system-icu? ( >=dev-libs/icu-67:= )
	system-ssl? ( >=dev-libs/openssl-1.1.1:0= )"
BDEPEND="${PYTHON_DEPS}
	sys-apps/coreutils
	virtual/pkgconfig
	systemtap? ( dev-util/systemtap )
	test? ( net-misc/curl )"
DEPEND="${RDEPEND}"

pkg_pretend() {
	(use x86 && ! use cpu_flags_x86_sse2) && \
		die "Your CPU doesn't support the required SSE2 instruction."
	if [[ ${MERGE_TYPE} != "binary" ]]; then
		if use lto; then
			if tc-is-gcc; then
				if [[ $(gcc-major-version) -ge 11 ]]; then
					# Bug #787158
					die "LTO builds of ${PN} using gcc-11+ currently fail tests and produce runtime errors. Either switch to gcc-10 or unset USE=lto for this ebuild"
				fi
			fi
		fi
	fi
}

src_prepare() {
	tc-export AR CC CXX PKG_CONFIG
	export V=1
	export BUILDTYPE=Release

	if use debug; then
		BUILDTYPE=Debug
	fi

	rm -f test/parallel/test-release-npm.js

	default
}

src_configure() {
	xdg_environment_reset

	# LTO compiler flags are handled by configure.py itself
	filter-flags '-flto*'

	local myconf=(
		--shared-brotli
		--shared-cares
		--shared-libuv
		--shared-nghttp2
		--shared-zlib
	)
	use debug && myconf+=( --debug )
	use lto && myconf+=( --enable-lto )
	if use system-icu; then
		myconf+=( --with-intl=system-icu )
	elif use icu; then
		myconf+=( --with-intl=full-icu )
	else
		myconf+=( --with-intl=none )
	fi
	use inspector || myconf+=( --without-inspector )
	use npm || myconf+=( --without-npm )
	use snapshot || myconf+=( --without-node-snapshot )
	if use ssl; then
		use system-ssl && myconf+=( --shared-openssl --openssl-use-def-ca-store )
	else
		myconf+=( --without-ssl )
	fi

	local myarch=""
	case ${ABI} in
		amd64) myarch="x64";;
		arm) myarch="arm";;
		arm64) myarch="arm64";;
		lp64*) myarch="riscv64";;
		ppc64) myarch="ppc64";;
		x32) myarch="x32";;
		x86) myarch="ia32";;
		*) myarch="${ABI}";;
	esac

	GYP_DEFINES="linux_use_gold_flags=0
		linux_use_bundled_binutils=0
		linux_use_bundled_gold=0" \
	"${EPYTHON}" configure.py \
		--prefix="${EPREFIX}"/usr \
		--dest-cpu=${myarch} \
		$(use_with systemtap dtrace) \
		"${myconf[@]}" || die
}

src_compile() {
	emake -C out
}

src_install() {
	local LIBDIR="${ED}/usr/$(get_libdir)"
	default

	# set up a symlink structure that node-gyp expects..
	dodir /usr/include/node/deps/{v8,uv}
	dosym . /usr/include/node/src
	for var in deps/{uv,v8}/include; do
		dosym ../.. /usr/include/node/${var}
	done

	if use doc; then
		docinto html
		dodoc -r "${S}"/doc/*
	fi

	if use npm; then
		keepdir /etc/npm

		# Install bash completion for `npm`
		local tmp_npm_completion_file="$(TMPDIR="${T}" mktemp -t npm.XXXXXXXXXX)"
		"${ED}/usr/bin/npm" completion > "${tmp_npm_completion_file}"
		newbashcomp "${tmp_npm_completion_file}" npm

		# Move man pages
		doman "${LIBDIR}"/node_modules/npm/man/man{1,5,7}/*

		# Clean up
		rm -f "${LIBDIR}"/node_modules/npm/{.mailmap,.npmignore,Makefile}
		rm -rf "${LIBDIR}"/node_modules/npm/{doc,html,man}

		local find_exp="-or -name"
		local find_name=()
		for match in "AUTHORS*" "CHANGELOG*" "CONTRIBUT*" "README*" \
			".travis.yml" ".eslint*" ".wercker.yml" ".npmignore" \
			"*.md" "*.markdown" "*.bat" "*.cmd"; do
			find_name+=( ${find_exp} "${match}" )
		done
	fi

	mv "${ED}"/usr/share/doc/node "${ED}"/usr/share/doc/${PF} || die
}

src_test() {
	if has usersandbox ${FEATURES}; then
		rm -f "${S}"/test/parallel/test-fs-mkdir.js
		ewarn "You are emerging ${PN} with 'usersandbox' enabled. Excluding tests known to fail in this mode." \
			"For full test coverage, emerge =${CATEGORY}/${PF} with 'FEATURES=-usersandbox'."
	fi

	out/${BUILDTYPE}/cctest || die
	"${EPYTHON}" tools/test.py --mode=${BUILDTYPE,,} --flaky-tests=dontcare -J message parallel sequential || die
}
