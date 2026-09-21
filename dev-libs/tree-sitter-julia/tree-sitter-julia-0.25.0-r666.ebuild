# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Upstream (::gentoo) ebuild doesn't enable the eclass's [python] binding at
# all; graphify needs it, so fork just to add that.
TS_BINDINGS=( python )

inherit tree-sitter-grammar

DESCRIPTION="Julia grammar for Tree-sitter"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter-julia"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
