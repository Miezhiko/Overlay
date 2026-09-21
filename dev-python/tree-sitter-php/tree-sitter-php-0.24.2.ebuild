# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_14 )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="PHP Python bindings for Tree-sitter"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter-php"

# Same situation as dev-python/tree-sitter-typescript: dev-libs/tree-sitter-php
# only builds the "php" grammar's C library from the php/ subdirectory (no
# Python bindings); the actual PyPI package "tree-sitter-php" that graphify
# depends on is built from the *repo root*, combining both php/src and
# php_only/src into one extension exposing language_php() and
# language_php_only(). Build that here as its own package instead.
SRC_URI="https://github.com/tree-sitter/tree-sitter-php/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/tree-sitter-0.24[${PYTHON_USEDEP}]
"

src_prepare() {
	default

	# Upstream's pyproject.toml has `license = "LICENSE"` -- a bare string
	# that's neither a valid SPDX identifier nor a {file=...}/{text=...}
	# table, so modern setuptools' PEP 639 validator rejects it outright.
	# It's actually just MIT (see LICENSE file); fix the field so the
	# wheel build doesn't die validating metadata.
	sed -i 's|^license = "LICENSE"|license = "MIT"|' pyproject.toml || die
	grep -q '^license = "MIT"' pyproject.toml || die "license field substitution didn't match"
}
