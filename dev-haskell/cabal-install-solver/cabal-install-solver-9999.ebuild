# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CABAL_PN="cabal-install-solver"

CABAL_FEATURES="test-suite lib"
inherit haskell-cabal git-r3

LIVE_EBUILD=yes

DESCRIPTION="Solver component of the cabal tool"
HOMEPAGE="https://www.haskell.org/cabal/"
EGIT_REPO_URI="https://github.com/haskell/cabal.git"

S="${S}"/"${PN}"
KEYWORDS="~amd64 ~x86"

LICENSE="BSD"
SLOT="0"
IUSE="debug-conflict-sets +native-dns debug +lukko"

RDEPEND=">=dev-haskell/async-2.0:=
	>=dev-haskell/base16-bytestring-0.1.1:=
	>=dev-haskell/cabal-3.3:=
	>=dev-haskell/cryptohash-sha256-0.11:=
	>=dev-haskell/echo-0.1.3:=
	>=dev-haskell/edit-distance-0.2.2:=
	>=dev-haskell/fail-4.9:=
	>=dev-haskell/hackage-security-0.6.0.0:=
	>=dev-haskell/hashable-1.0:=
	>=dev-haskell/http-4000.1.5:=
	lukko? ( >=dev-haskell/lukko-0.1:= )
	>=dev-haskell/mtl-2.0:=
	>=dev-haskell/network-2.6:=
	>=dev-haskell/network-uri-2.6.0.2:=
	>=dev-haskell/parsec-3.1.13.0:=
	>=dev-haskell/random-1:=
	>=dev-haskell/semigroups-0.18.3:=
	>=dev-haskell/stm-2.0:=
	>=dev-haskell/tar-0.5.0.3:=
	>=dev-haskell/text-1.2.3:=
	>=dev-haskell/zlib-0.5.3:=
	>=dev-lang/ghc-7.10.1:=
	native-dns? ( >=dev-haskell/resolv-0.1.1:= )
"
DEPEND="${RDEPEND}
	=dev-haskell/cabal-9999
"

src_prepare() {
	# no chance to link to -threaded on ppc64, alpha and others
	# who use UNREG, not only ARM
	if ! ghc-supports-threaded-runtime; then
		cabal_chdeps '-threaded' ' '
	fi
	eapply_user
}

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag debug debug-conflict-sets) \
		--flag=-debug-expensive-assertions \
		--flag=-debug-tracetree \
		$(cabal_flag lukko lukko) \
		--flag=-monolithic \
		$(cabal_flag native-dns native-dns) \
		--flag=network-uri
}

