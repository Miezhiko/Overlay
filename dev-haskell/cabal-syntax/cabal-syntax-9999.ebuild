# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CABAL_PN="Cabal-syntax"

CABAL_FEATURES="lib profile haddock hoogle hscolour" # drop tests due to circular deps
CABAL_FEATURES+=" nocabaldep" # in case installed Cabal is broken

inherit haskell-cabal git-r3

LIVE_EBUILD=yes

DESCRIPTION="The .cabal file format library"
HOMEPAGE="https://www.haskell.org/cabal/"

LICENSE="BSD"
SLOT="0/${PV}"

EGIT_REPO_URI="https://github.com/haskell/cabal.git"
S="${WORKDIR}"/cabal-syntax-9999/"${CABAL_PN}"
KEYWORDS="~amd64 ~x86"

RESTRICT=test # circular deps: cabal -> quickcheck -> cabal

RDEPEND=">=dev-lang/ghc-9:="
DEPEND="${RDEPEND}"

src_prepare() {
	# Cabal bootstraps with 'ghc --make' without package cleanup in environment.
	# That causes module collisions at build:
	# - pulseaudio: Distribution/Utils/Structured.hs:98:1: error: Ambiguous module name ‘Data.Time’: it was found in multiple packages: pulseaudio-0.0.2.1 time-1.9.3
	# - kinds: Distribution/Utils/Structured.hs:106:1: error: Ambiguous module name ‘Data.Kind’: it was found in multiple packages: base-4.14.1.0 kinds-0.0.1.5
	HCFLAGS="${HCFLAGS} -ignore-package=pulseaudio"
	HCFLAGS="${HCFLAGS} -ignore-package=kinds"
	eapply_user
}

src_configure() {
	haskell-cabal_src_configure \
		--flag=-parsec-struct-diff
}

CABAL_CORE_LIB_GHC_PV="PM:9.2.4 PM:9999"
