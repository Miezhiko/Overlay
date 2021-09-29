# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools multilib-minimal libtool

MY_PN=libidn
MY_P=${MY_PN}-${PV}

DESCRIPTION="Internationalized Domain Names (IDN) implementation"
HOMEPAGE="https://www.gnu.org/software/libidn/"
SRC_URI="
	mirror://gnu/libidn/${MY_P}.tar.gz
	https://dev.gentoo.org/~polynomial-c/${MY_P}-security_backports-01.tar.xz
"

LICENSE="GPL-2 GPL-3 LGPL-3"
SLOT="1.33"
KEYWORDS="~amd64 ~x86"

RDEPEND="!<${CATEGORY}/${MY_PN}-1.35:0"

PATCHES=(
	"${FILESDIR}"/${MY_PN}-1.33-parallel-make.patch
)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	eapply "${WORKDIR}"/patches

	# breaks eautoreconf
	sed '/AM_INIT_AUTOMAKE/s@ -Werror@@' -i configure.ac || die
	# Breaks build because --disable-gtk-doc* gets ignored
	sed '/^SUBDIRS/s@ doc@@' -i Makefile.am || die
	eautoreconf
	elibtoolize  # for Solaris shared objects
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-java
		--disable-csharp
		--disable-nls
		--disable-static
		--disable-silent-rules
		--disable-valgrind-tests
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_test() {
	# only run libidn specific tests and not gnulib tests (bug #539356)
	emake -C tests check
}

multilib_src_install() {
	dolib.so lib/.libs/libidn.so.11*
}
