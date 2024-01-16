# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal git-r3

DESCRIPTION="A native HTTP2 client library"
HOMEPAGE="https://github.com/lucasdicioccio/http2-client"

EGIT_REPO_URI="https://github.com/haskell-grpc-native/http2-client.git"
EGIT_COMMIT="ebd264951eeb69cdc500cd61e263e2dfde516ac7"
SRC_URI=""

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"

PATCHES="
	${FILESDIR}/89.patch
	${FILESDIR}/my.patch
"

RDEPEND=">=dev-haskell/async-2.1:=[profile?] <dev-haskell/async-3:=[profile?]
	>=dev-haskell/http2-1.6:=[profile?] <dev-haskell/http2-5:=[profile?]
	>=dev-haskell/lifted-async-0.10:=[profile?] <dev-haskell/lifted-async-0.11:=[profile?]
	>=dev-haskell/lifted-base-0.2:=[profile?] <dev-haskell/lifted-base-0.3:=[profile?]
	>=dev-haskell/network-2.6:=[profile?] <dev-haskell/network-4:=[profile?]
	>=dev-haskell/tls-1.4:=[profile?] <dev-haskell/tls-2:=[profile?]
	>=dev-haskell/transformers-base-0.4:=[profile?] <dev-haskell/transformers-base-0.5:=[profile?]
	>=dev-lang/ghc-8.10.6:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-3.2.1.0
"
