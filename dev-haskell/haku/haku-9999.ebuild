# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CABAL_FEATURES="bin profile haddock hoogle hscolour"
inherit haskell-cabal git-r3

CABAL_PN="Haku"

MY_PN="Haku"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="scripty thing experiment"
HOMEPAGE="https://github.com/Miezhiko/${MY_PN}"
EGIT_REPO_URI="https://github.com/Miezhiko/${MY_PN}.git"

LICENSE="LGPLv2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-haskell/base-unicode-symbols:=[profile?]
	dev-haskell/split
	dev-haskell/parsec
	>=dev-lang/ghc-8.0:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.0
"

S="${WORKDIR}/${P}"

src_configure() {
	cabal-mksetup
	haskell-cabal_src_configure
}
