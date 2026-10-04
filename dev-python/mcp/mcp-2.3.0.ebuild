# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )
DISTUTILS_USE_PEP517=hatchling

inherit distutils-r1

DESCRIPTION="Python SDK for Model Context Protocol"
HOMEPAGE="https://github.com/modelcontextprotocol/python-sdk"
SRC_URI="https://files.pythonhosted.org/packages/source/m/mcp/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

BDEPEND="
	>=dev-python/uv-dynamic-versioning-0.14.0[${PYTHON_USEDEP}]
"

RDEPEND="
	>=dev-python/agent-client-protocol-0.6.3[${PYTHON_USEDEP}]
	dev-python/anyio[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.20.0[${PYTHON_USEDEP}]
	dev-python/httpx-sse[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/starlette[${PYTHON_USEDEP}]
	dev-python/sse-starlette[${PYTHON_USEDEP}]
"
