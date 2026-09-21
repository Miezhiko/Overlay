# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This overlay only has python3_14 enabled (PYTHON_TARGETS in make.conf), so
# match that instead of the full python3_{12..15} range dev-libs/tree-sitter-*
# grammar packages' own [python] USE flag supports (see
# dev-libs/tree-sitter-grammar.eclass) -- pinning to a wider, partly-unbuilt
# range made every "[python,${PYTHON_USEDEP}]" RDEPEND atom below demand ALL
# of python3_12/13/14/15 simultaneously instead of just the one actually
# enabled, which portage can't satisfy ("no ebuilds built with USE flags to
# satisfy ...").
PYTHON_COMPAT=( python3_14 )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 git-r3

DESCRIPTION="Turn a codebase into a queryable knowledge graph for AI coding assistants"
HOMEPAGE="https://github.com/Graphify-Labs/graphify"

# Upstream's default branch is oddly named "v8" (not a release tag; the
# actual PyPI/tag version at the time of writing is 0.9.65). Track it live
# rather than a release tarball since upstream cuts PyPI releases (as
# "graphifyy", a squat-dodging rename) far more often than tags.
EGIT_REPO_URI="https://github.com/Graphify-Labs/graphify.git"
EGIT_BRANCH="v8"

# Dual Apache-2.0/MIT upstream (see LICENSE + LICENSE-MIT in the repo).
LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test" # test suite pulls in hypothesis, nuitka and friends, not packaged

# Upstream pins every tree-sitter* dependency's upper bound conservatively
# ("untested against yet", not a known break -- see e.g. the tree-sitter
# core note below); this overlay just floors them and lets whatever's
# actually installed satisfy the rest, rather than fight version-locked
# grammar packages that are otherwise perfectly API-compatible.
RDEPEND="
	>=dev-python/networkx-3.4[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.21[${PYTHON_USEDEP}]
	>=dev-python/rapidfuzz-3.0[${PYTHON_USEDEP}]
	>=dev-python/tree-sitter-0.23.0[${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-python-0.23[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-javascript-0.23[python,${PYTHON_USEDEP}]
	>=dev-python/tree-sitter-typescript-0.23[${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-go-0.23[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-rust-0.23[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-java-0.23[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-groovy-0.1[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-c-0.23[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-cpp-0.23[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-ruby-0.23[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-c-sharp-0.23[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-kotlin-1.0[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-scala-0.23[python,${PYTHON_USEDEP}]
	>=dev-python/tree-sitter-php-0.23[${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-swift-0.7[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-lua-0.2[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-zig-1.0[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-powershell-0.26[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-elixir-0.3[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-objc-3.0[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-julia-0.23[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-verilog-1.0[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-fortran-0.6[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-bash-0.23[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-json-0.23[python,${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-83.0.0[${PYTHON_USEDEP}]
"
