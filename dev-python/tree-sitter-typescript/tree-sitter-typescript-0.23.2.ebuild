# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_14 )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="TypeScript/TSX Python bindings for Tree-sitter"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter-typescript"

# Unlike dev-libs/tree-sitter-typescript and dev-libs/tree-sitter-tsx (which
# each build one grammar's standalone C library from its own subdirectory of
# this same upstream repo, with no Python bindings), the actual PyPI package
# "tree-sitter-typescript" that graphify (and its own pyproject.toml) depends
# on is built from the *repo root*: one compiled extension combining both
# typescript/src and tsx/src, exposing language_typescript() and
# language_tsx(). There is no clean way to get that single combined module
# out of the two split dev-libs packages, so build it here instead as its
# own package, matching upstream's actual PyPI distribution.
SRC_URI="https://github.com/tree-sitter/tree-sitter-typescript/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/tree-sitter-0.23[${PYTHON_USEDEP}]
"
