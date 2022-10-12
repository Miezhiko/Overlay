# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CABAL_PN="hackage-security"

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal git-r3

LIVE_EBUILD=yes

EGIT_REPO_URI="https://github.com/haskell/hackage-security.git"
S="${WORKDIR}/hackage-security-9999/${CABAL_PN}"

DESCRIPTION="Hackage security library"
HOMEPAGE="https://github.com/haskell/hackage-security"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+cabal-syntax +lukko"

RDEPEND=">=dev-haskell/base16-bytestring-0.1.1:=[profile?] <dev-haskell/base16-bytestring-1.1:=[profile?]
	>=dev-haskell/base64-bytestring-1.0:=[profile?] <dev-haskell/base64-bytestring-1.3:=[profile?]
	>=dev-haskell/cryptohash-sha256-0.11:=[profile?] <dev-haskell/cryptohash-sha256-0.12:=[profile?]
	>=dev-haskell/ed25519-0.0:=[profile?] <dev-haskell/ed25519-0.1:=[profile?]
	>=dev-haskell/network-uri-2.6:=[profile?] <dev-haskell/network-uri-2.7:=[profile?]
	>=dev-haskell/tar-0.5:=[profile?] <dev-haskell/tar-0.6:=[profile?]
	>=dev-haskell/zlib-0.5:=[profile?] <dev-haskell/zlib-0.7:=[profile?]
	>=dev-lang/ghc-8.4.3:=
	|| ( ( >=dev-haskell/network-2.6:=[profile?] <dev-haskell/network-2.9:=[profile?] )
		( >=dev-haskell/network-3.0:=[profile?] <dev-haskell/network-3.2:=[profile?] ) )
	cabal-syntax? ( >=dev-haskell/cabal-syntax-3.7:=[profile?] )
	lukko? ( >=dev-haskell/lukko-0.1:=[profile?] <dev-haskell/lukko-0.2:=[profile?] )
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.2.0.1
	test? ( >=dev-haskell/quickcheck-2.11 <dev-haskell/quickcheck-2.15
		>=dev-haskell/tasty-1.2 <dev-haskell/tasty-1.5
		>=dev-haskell/tasty-hunit-0.10 <dev-haskell/tasty-hunit-0.11
		>=dev-haskell/tasty-quickcheck-0.10 <dev-haskell/tasty-quickcheck-0.11
		>=dev-haskell/temporary-1.2 <dev-haskell/temporary-1.4
		>=dev-haskell/unordered-containers-0.2.8.0 <dev-haskell/unordered-containers-0.3
		>=dev-haskell/vector-0.12 <dev-haskell/vector-0.13
		|| ( ( >=dev-haskell/aeson-1.4 <dev-haskell/aeson-1.5 )
			|| ( ( >=dev-haskell/aeson-1.5 <dev-haskell/aeson-1.6 )
				|| ( ( >=dev-haskell/aeson-2.0 <dev-haskell/aeson-2.1 )
				( >=dev-haskell/aeson-2.1 <dev-haskell/aeson-2.2 ) ) ) )
		cabal-syntax? ( >=dev-haskell/cabal-3.7 ) )
"

src_prepare() {
	eapply_user
}

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag cabal-syntax cabal-syntax) \
		$(cabal_flag lukko lukko) \
		--flag=base48 \
		--flag=-mtl21 \
		--flag=use-network-uri
}
