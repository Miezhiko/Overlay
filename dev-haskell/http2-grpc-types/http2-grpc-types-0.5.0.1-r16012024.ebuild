# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CABAL_PN="${PN}"

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal git-r3

DESCRIPTION="Types for gRPC over HTTP2 common for client and servers"
HOMEPAGE="https://github.com/haskell-grpc-native/http2-grpc-haskell#readme"

EGIT_REPO_URI="https://github.com/haskell-grpc-native/http2-grpc-haskell.git"
EGIT_COMMIT="560766f5a8f8707c3ca26e413bf07ec1f1c26003"
SRC_URI=""

S="${WORKDIR}/${P}/${PN}"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"

RDEPEND=">=dev-haskell/case-insensitive-1.2.0:=[profile?] <dev-haskell/case-insensitive-1.3:=[profile?]
	>=dev-haskell/zlib-0.6.2:=[profile?] <dev-haskell/zlib-0.7:=[profile?]
	>=dev-lang/ghc-8.10.6:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-3.2.1.0
"

src_prepare() {
	# no chance to link to -threaded on ppc64, alpha and others
	# who use UNREG, not only ARM
	if ! ghc-supports-threaded-runtime; then
		cabal_chdeps '-threaded' ' '
	fi
	eapply_user
}
