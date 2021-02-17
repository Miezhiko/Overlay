# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KEYWORDS="~amd64"

DESCRIPTION="A purely functional programming language with first class types"
HOMEPAGE="https://github.com/idris-lang/Idris2"

if [[ ${PV} = 9999 ]]; then
  inherit git-r3
  EGIT_REPO_URI="https://github.com/Masha/Idris2.git"
  EGIT_BRANCH="destdir"
else
  SRC_URI="https://github.com/idris-lang/Idris2/archive/v${PV}.tar.gz"
  S="${WORKDIR}/Idris2-${PV}"
fi

RESTRICT="mirror test"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}
  dev-scheme/chezscheme
"

#TODO: prefix should be with D but without D
src_prepare() {
  sed -i 's|PREFIX ?= $(HOME)/.idris2|PREFIX = /usr|g' config.mk || die
  make bootstrap SCHEME=chez
  default
}

src_configure() { :; }
src_compile() { :; }
src_test() { :; }

src_install() {
  # idris2 --install doesn't support destir :(
  addwrite "/usr/idris2-0.3.0/"
	default
	# move stuff back to destidr
	mv "/usr/idris2-0.3.0/"* "${D}/usr/idris2-0.3.0/"
	mkdir "${D}/usr/lib64" || die
  mv "${D}/usr/lib"/* "${D}/usr/lib64/" || die
  rm -r "${D}/usr/lib/"
}
