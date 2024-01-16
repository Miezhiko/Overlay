# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CABAL_PN="${PN}"

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal git-r3

DESCRIPTION="Implement gRPC-over-HTTP2 clients"
HOMEPAGE="https://github.com/haskell-grpc-native/http2-grpc-haskell/blob/master/http2-client-grpc/README.md"

EGIT_REPO_URI="https://github.com/haskell-grpc-native/http2-grpc-haskell.git"
EGIT_COMMIT="560766f5a8f8707c3ca26e413bf07ec1f1c26003"
SRC_URI=""

S="${WORKDIR}/${P}/${PN}"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"

RDEPEND=">=dev-haskell/async-2.2:=[profile?] <dev-haskell/async-2.3:=[profile?]
	>=dev-haskell/case-insensitive-1.2.0:=[profile?] <dev-haskell/case-insensitive-1.3:=[profile?]
	>=dev-haskell/data-default-class-0.1:=[profile?] <dev-haskell/data-default-class-0.2:=[profile?]
	>=dev-haskell/http2-1.6:=[profile?] <dev-haskell/http2-5:=[profile?]
	>=dev-haskell/http2-client-0.9:=[profile?] <dev-haskell/http2-client-0.11:=[profile?]
	>=dev-haskell/http2-grpc-types-0.5:=[profile?] <dev-haskell/http2-grpc-types-0.6:=[profile?]
	>=dev-haskell/lifted-async-0.10:=[profile?] <dev-haskell/lifted-async-0.11:=[profile?]
	>=dev-haskell/lifted-base-0.2:=[profile?] <dev-haskell/lifted-base-0.3:=[profile?]
	>=dev-haskell/text-1.2:=[profile?] <dev-haskell/text-3:=[profile?]
	>=dev-haskell/tls-1.4:=[profile?] <dev-haskell/tls-1.9:=[profile?]
	>=dev-lang/ghc-8.10.6:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-3.2.1.0
"

PATCHES="
	${FILESDIR}/my.patch
"

src_prepare() {
	# no chance to link to -threaded on ppc64, alpha and others
	# who use UNREG, not only ARM
	if ! ghc-supports-threaded-runtime; then
		cabal_chdeps '-threaded' ' '
	fi
	default
}
