# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TS_BINDINGS=( python )

inherit tree-sitter-grammar

DESCRIPTION="Fortran grammar for Tree-sitter"
HOMEPAGE="https://github.com/stadelmanma/tree-sitter-fortran"

# Not under the tree-sitter org, unlike most grammars the eclass defaults to.
SRC_URI="https://github.com/stadelmanma/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
