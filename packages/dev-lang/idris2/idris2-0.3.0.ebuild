# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KEYWORDS="~amd64"

DESCRIPTION="A purely functional programming language with first class types"
HOMEPAGE="https://github.com/idris-lang/Idris2"
SRC_URI="https://github.com/idris-lang/Idris2/archive/v${PV}.tar.gz"

RESTRICT="mirror test"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}
  dev-scheme/chezscheme
"

S="${WORKDIR}/Idris2-${PV}"

#TODO: prefix should be with D but without D
src_prepare() {
  sed -i 's|PREFIX ?= $(HOME)/.idris2|PREFIX = ${D}/usr|g' config.mk || die
  make bootstrap SCHEME=chez
  default
}

src_configure() { :; }
src_compile() { :; }
src_test() { :; }

src_install() {
	default
	mkdir "${D}/usr/lib64" || die
  mv "${D}/usr/lib"/* "${D}/usr/lib64/" || die
  rm -r "${D}/usr/lib/"
  #mv "${D}/usr/${P}" "${D}/usr/share/${P}"
  #mv "${D}/usr/bin/idris2_app"/*.so  "${D}/usr/lib64/"
  #mv "${D}/usr/bin/idris2_app"/* "${D}/usr/bin/"
  #rm -r "${D}/usr/bin/idris2_app"
}
