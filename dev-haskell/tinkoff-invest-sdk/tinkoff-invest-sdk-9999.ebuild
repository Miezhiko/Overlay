# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CABAL_PN="${PN}"

GHC_BOOTSTRAP_PACKAGES=(
	proto-lens-setup
)

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal git-r3

DESCRIPTION="gRPC based SDK for Tinkoff Invest API V2"
HOMEPAGE="https://github.com/nickmi11er/tinkoff-invest-haskell#readme"

EGIT_REPO_URI="https://github.com/Masha/tinkoff-invest-haskell.git"
SRC_URI=""

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"

S="${WORKDIR}/${P}/sdk"

RDEPEND=">=dev-haskell/async-2.2.4:=[profile?] <dev-haskell/async-2.3:=[profile?]
	>=dev-haskell/concurrent-extra-0.7:=[profile?] <dev-haskell/concurrent-extra-0.8:=[profile?]
	>=dev-haskell/errors-2.3.0:=[profile?] <dev-haskell/errors-2.4:=[profile?]
	>=dev-haskell/http2-client-0.10.0.1:=[profile?] <dev-haskell/http2-client-0.11:=[profile?]
	>=dev-haskell/http2-client-grpc-0.8.0.0:=[profile?] <dev-haskell/http2-client-grpc-0.9:=[profile?]
	>=dev-haskell/http2-grpc-proto-lens-0.1.0.0:=[profile?] <dev-haskell/http2-grpc-proto-lens-0.2:=[profile?]
	>=dev-haskell/lens-5.0.1:=[profile?] <dev-haskell/lens-10:=[profile?]
	>=dev-haskell/proto-lens-0.7.1.1:=[profile?] <dev-haskell/proto-lens-0.8:=[profile?]
	>=dev-haskell/proto-lens-runtime-0.7.0.2:=[profile?] <dev-haskell/proto-lens-runtime-0.8:=[profile?]
	>=dev-haskell/text-1.2.5.0:=[profile?] <dev-haskell/text-3:=[profile?]
	>=dev-haskell/unordered-containers-0.2.17.0:=[profile?] <dev-haskell/unordered-containers-0.3:=[profile?]
	dev-haskell/transformers
	>=dev-lang/ghc-9.0.2:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-3.4.1.0
	>=dev-haskell/proto-lens-setup-0.4.0.6
"

src_prepare() {
	# no chance to link to -threaded on ppc64, alpha and others
	# who use UNREG, not only ARM
	if ! ghc-supports-threaded-runtime; then
		cabal_chdeps '-threaded' ' '
	fi
	default
}
