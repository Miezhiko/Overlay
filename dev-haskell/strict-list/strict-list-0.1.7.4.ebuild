# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ebuild generated by hackport 0.8.5.1.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Strict linked list"
HOMEPAGE="https://github.com/nikita-volkov/strict-list"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"

RDEPEND=">=dev-haskell/hashable-1.2:=[profile?] <dev-haskell/hashable-2:=[profile?]
	>=dev-haskell/semigroupoids-5.3:=[profile?] <dev-haskell/semigroupoids-7:=[profile?]
	>=dev-lang/ghc-9.0.2:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-3.4.1.0
	test? ( <dev-haskell/rerebase-2
		>=dev-haskell/tasty-0.12 <dev-haskell/tasty-2
		>=dev-haskell/tasty-quickcheck-0.9 <dev-haskell/tasty-quickcheck-0.11 )
"
