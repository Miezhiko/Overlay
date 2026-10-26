# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="SSE plugin for Starlette"
HOMEPAGE="https://github.com/sysid/sse-starlette"
SRC_URI="https://github.com/sysid/sse-starlette/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

RDEPEND="
	>=dev-python/starlette-0.49.1[${PYTHON_USEDEP}]
	>=dev-python/anyio-4.7.0[${PYTHON_USEDEP}]
"

