# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=hatchling

inherit distutils-r1

DESCRIPTION="Minimal CLI coding agent by Mistral"
HOMEPAGE="https://github.com/mistralai/mistral-vibe"
SRC_URI="https://github.com/mistralai/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-libs/tree-sitter-bash-0.25.1[${PYTHON_USEDEP}]
	~dev-python/agent-client-protocol-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/anyio-4.12[${PYTHON_USEDEP}]
	dev-python/cachetools[${PYTHON_USEDEP}]
	>=dev-python/cryptography-44.0.0[${PYTHON_USEDEP}]
	>=dev-python/debugpy-1.8.19[${PYTHON_USEDEP}]
	>=dev-python/gitpython-3.1.46[${PYTHON_USEDEP}]
	>=dev-python/giturlparse-0.14.0[${PYTHON_USEDEP}]
	dev-python/google-auth[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.28.1[${PYTHON_USEDEP}]
	>=dev-python/keyring-25.6.0[${PYTHON_USEDEP}]
	dev-python/markdownify[${PYTHON_USEDEP}]
	>=dev-python/mcp-1.14.0[${PYTHON_USEDEP}]
	>=dev-python/mistralai-2.1.3[${PYTHON_USEDEP}]
	dev-python/opentelemetry-api[${PYTHON_USEDEP}]
	dev-python/opentelemetry-sdk[${PYTHON_USEDEP}]
	dev-python/opentelemetry-semantic-conventions[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.9.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-24.1[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/pydantic-settings[${PYTHON_USEDEP}]
	>=dev-python/pyperclip-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/python-dotenv-1.0.0[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/rich-14.0.0[${PYTHON_USEDEP}]
	>=dev-python/textual-8.1.1[${PYTHON_USEDEP}]
	dev-python/textual_speedups[${PYTHON_USEDEP}]
	>=dev-python/tomli-w-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/tree-sitter-0.25.2[${PYTHON_USEDEP}]
	>=dev-python/sounddevice-0.5.1[${PYTHON_USEDEP}]
	dev-python/watchfiles[${PYTHON_USEDEP}]
	dev-python/websockets[${PYTHON_USEDEP}]
	>=dev-python/zstandard-0.25.0[${PYTHON_USEDEP}]
	dev-python/opentelemetry-exporter-otlp-proto-http[${PYTHON_USEDEP}]
	dev-python/jsonpatch[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/editables[${PYTHON_USEDEP}]
	dev-python/truststore[${PYTHON_USEDEP}]
"

RESTRICT="test"
