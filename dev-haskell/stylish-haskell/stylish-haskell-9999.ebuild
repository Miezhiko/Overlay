# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal git-r3

LIVE_EBUILD=yes

DESCRIPTION="Haskell code prettifier"
HOMEPAGE="https://github.com/haskell/stylish-haskell"
EGIT_REPO_URI="https://github.com/Qeenon/stylish-haskell.git"
EGIT_BRANCH="mawa"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="ghc-lib"

# TEMPORARY HACK FOR PERSONAL NEEDS!
#	>=dev-haskell/ghc-lib-parser-9.4:=[profile?] <dev-haskell/ghc-lib-parser-9.5:=[profile?]
#	>=dev-haskell/ghc-lib-parser-ex-9.4.0:=[profile?] <dev-haskell/ghc-lib-parser-ex-9.5:=[profile?]

RDEPEND=">=dev-haskell/aeson-0.6:=[profile?] <dev-haskell/aeson-2.1:=[profile?]
	>=dev-haskell/cabal-3.4:=[profile?]
	>=dev-haskell/file-embed-0.0.10:=[profile?] <dev-haskell/file-embed-0.1:=[profile?]

	>=dev-haskell/hsyaml-0.2.0:=[profile?] <dev-haskell/hsyaml-0.3:=[profile?]
	>=dev-haskell/hsyaml-aeson-0.2.0:=[profile?] <dev-haskell/hsyaml-aeson-0.3:=[profile?]
	>=dev-haskell/optparse-applicative-0.12:=[profile?] <dev-haskell/optparse-applicative-0.18:=[profile?]
	>=dev-haskell/strict-0.3:=[profile?] <dev-haskell/strict-0.5:=[profile?]
	>=dev-haskell/syb-0.3:=[profile?] <dev-haskell/syb-0.8:=[profile?]
	>=dev-lang/ghc-8.4.3:=
	>=dev-haskell/regex-tdfa-1.3
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.4
	test? ( >=dev-haskell/hunit-1.2 <dev-haskell/hunit-1.7
		>=dev-haskell/random-1.1
		>=dev-haskell/test-framework-0.4 <dev-haskell/test-framework-0.9
		>=dev-haskell/test-framework-hunit-0.2 <dev-haskell/test-framework-hunit-0.4 )
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag ghc-lib ghc-lib)
}
