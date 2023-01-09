# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit haskell-cabal git-r3

DESCRIPTION="time tracker"
HOMEPAGE="https://github.com/Miezhiko/T"
EGIT_REPO_URI="https://github.com/Miezhiko/T.git"
EGIR_REPO_BRANCH="mawa"
SRC_URI=""

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-lang/ghc-8
	dev-haskell/utf8-string
	dev-haskell/missingh
	dev-haskell/base-unicode-symbols
	dev-haskell/executable-path
	dev-haskell/lifted-base
	dev-haskell/yaml"

DEPEND="${RDEPEND}"
