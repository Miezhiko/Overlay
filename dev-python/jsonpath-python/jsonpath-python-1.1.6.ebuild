# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )
DISTUTILS_USE_PEP517=hatchling

inherit distutils-r1

DESCRIPTION="A lightweight and powerful JSONPath implementation for Python"
HOMEPAGE="https://github.com/sean2077/jsonpath-python"
SRC_URI="https://github.com/sean2077/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"
