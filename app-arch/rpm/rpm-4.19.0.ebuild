# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{3,4} )
PYTHON_COMPAT=( python3_{10..12} )

inherit cmake lua-single perl-module python-single-r1 toolchain-funcs

CMAKE_MAKEFILE_GENERATOR=emake

DESCRIPTION="Red Hat Package Management Utils"
HOMEPAGE="https://rpm.org/ https://github.com/rpm-software-management/rpm"
SRC_URI="
	https://ftp.osuosl.org/pub/rpm/releases/rpm-$(ver_cut 1-2).x/${P}.tar.bz2
	http://ftp.rpm.org/releases/rpm-$(ver_cut 1-2).x/${P}.tar.bz2
"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="acl audit caps +berkdb doc dbus nls openmp python readline selinux +sqlite test +zstd"
REQUIRED_USE="
	${LUA_REQUIRED_USE}
	python? ( ${PYTHON_REQUIRED_USE} )
"
# Tests are broken. See bug #657500
RESTRICT="test"

DEPEND="
	${LUA_DEPS}
	!app-arch/rpm5
	app-arch/libarchive:=
	>=app-arch/bzip2-1.0.1
	app-arch/xz-utils
	>=app-crypt/gnupg-1.2
	>=dev-lang/perl-5.8.8
	dev-libs/elfutils
	dev-libs/libgcrypt:=
	>=dev-libs/popt-1.7
	sys-apps/file
	>=sys-libs/zlib-1.2.3-r1
	virtual/libintl
	acl? ( virtual/acl )
	audit? ( sys-process/audit )
	caps? ( >=sys-libs/libcap-2.0 )
	dbus? ( sys-apps/dbus )
	readline? ( sys-libs/readline:= )
	sqlite? ( dev-db/sqlite:3 )
	python? ( ${PYTHON_DEPS} )
	nls? ( virtual/libintl )
	zstd? ( app-arch/zstd:= )
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	nls? ( sys-devel/gettext )
	test? ( sys-apps/fakechroot )
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-rpm )
"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	lua-single_pkg_setup

	use python && python-single-r1_pkg_setup

	# bug #779769
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default

	# bug #356769
	sed -i 's:%{_var}/tmp:/var/tmp:' macros.in || die "Fixing tmppath failed"
	# bug #492642
	sed -i "s:@__PYTHON@:${PYTHON}:" macros.in || die "Fixing %__python failed"
	
	cmake_src_prepare
}

src_configure() {
        local mycmakeargs=(
        		-DWITH_INTERNAL_OPENPGP=ON
                -DWITH_SELINUX=OFF
                -DWITH_AUDIT=OFF
                -DWITH_FSVERITY=OFF
                -DWITH_IMAEVM=OFF
                -DWITH_FAPOLICYD=OFF
        )
        cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
}

pkg_postinst() {
	if [[ -f "${EROOT}"/var/lib/rpm/Packages ]] ; then
		einfo "RPM database found... Rebuilding database (may take a while)..."
		"${EROOT}"/usr/bin/rpmdb --rebuilddb --root="${EROOT}/" || die
	else
		einfo "No RPM database found... Creating database..."
		"${EROOT}"/usr/bin/rpmdb --initdb --root="${EROOT}/" || die
	fi
}
