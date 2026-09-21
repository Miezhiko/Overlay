# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TS_BINDINGS=( python )

inherit tree-sitter-grammar

DESCRIPTION="Elixir grammar for Tree-sitter"
HOMEPAGE="https://github.com/elixir-lang/tree-sitter-elixir"

# Not under the tree-sitter org, unlike most grammars the eclass defaults to.
SRC_URI="https://github.com/elixir-lang/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_prepare() {
	tree-sitter-grammar_src_prepare

	# Unlike most grammars' Makefiles, this one's "install" target installs
	# bindings/c/tree-sitter-elixir.h directly, but no "all" (or any other)
	# target ever generates it from the bundled .in template -- an upstream
	# oversight. Render it ourselves the same way the other grammars' own
	# Makefiles do it.
	sed -e 's|@UPPER_PARSERNAME@|ELIXIR|' -e 's|@PARSERNAME@|elixir|' \
		bindings/c/tree-sitter.h.in > bindings/c/tree-sitter-elixir.h || die
}
