# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TS_BINDINGS=( python )

# Upstream tags plain releases without pre-generated parser.c; only the
# "-with-generated-files" tag variant ships src/parser.c, which the ebuild
# needs (we don't run tree-sitter generate at build time).
TS_PV="${PV}-with-generated-files"

inherit tree-sitter-grammar

DESCRIPTION="Swift grammar for Tree-sitter"
HOMEPAGE="https://github.com/alex-pinkus/tree-sitter-swift"

# Not under the tree-sitter org, unlike most grammars the eclass defaults
# to; also no "v" tag prefix (see TS_PV above).
SRC_URI="https://github.com/alex-pinkus/${PN}/archive/${TS_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_prepare() {
	tree-sitter-grammar_src_prepare

	# The top-level Makefile's `SRC := $(wildcard src/*.c)` blindly grabs
	# every .c file, including these two alternate-ABI parser variants
	# (each defining its own tree_sitter_swift() symbol), so linking the
	# shared lib fails with "duplicate symbol: tree_sitter_swift". They're
	# for other consumers targeting older/newer ABIs specifically; our own
	# ABI comes from plain src/parser.c, which upstream's own setup.py also
	# builds against exclusively.
	rm src/parser_abi13.c src/parser_abi14.c || die
}
