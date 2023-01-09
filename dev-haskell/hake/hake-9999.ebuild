# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CABAL_FEATURES="bin lib profile haddock hoogle hscolour"
inherit haskell-cabal git-r3

MY_PN="hake"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="scripty thing"
HOMEPAGE="https://github.com/Miezhiko/hake"
EGIT_REPO_URI="https://github.com/Miezhiko/hake.git"

LICENSE="LGPLv2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-haskell/missingh:=[profile?]
	dev-haskell/base-unicode-symbols:=[profile?]
	dev-haskell/split:=[profile?]
	>=dev-lang/ghc-8.0:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.0
"

S="${WORKDIR}/${MY_P}"

src_configure() {
	cabal-mksetup
	haskell-cabal_src_configure
}
