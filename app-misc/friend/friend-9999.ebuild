# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CABAL_FEATURES=""
inherit haskell-cabal git-r3

DESCRIPTION="Terminal chat client for OpenAI-compatible servers"
HOMEPAGE="https://github.com/Miezhiko/friend"
EGIT_REPO_URI="https://github.com/Miezhiko/friend.git"

LICENSE="Quadrober"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="net-misc/curl
	>=dev-lang/ghc-9.12:=
	>=dev-haskell/aeson-2:=
	dev-haskell/async:=
	dev-haskell/network:=
	dev-haskell/network-uri:=
	dev-haskell/optparse-applicative:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-3.0
"

DOCS=( README.md )
