# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="The official Python library for the OpenAI API"
HOMEPAGE="
	https://github.com/openai/openai-python
	https://pypi.org/project/openai/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="aiohttp bedrock"

RDEPEND="
	>=dev-python/anyio-4.10.0[${PYTHON_USEDEP}]
	<dev-python/anyio-5[${PYTHON_USEDEP}]
	>=dev-python/httpx2-2.12.0[${PYTHON_USEDEP}]
	<dev-python/httpx2-3[${PYTHON_USEDEP}]
	>=dev-python/jiter-0.16.0[${PYTHON_USEDEP}]
	<dev-python/jiter-1[${PYTHON_USEDEP}]
	>=dev-python/pydantic-1.10.13[${PYTHON_USEDEP}]
	<dev-python/pydantic-3[${PYTHON_USEDEP}]
	dev-python/sniffio[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.14[${PYTHON_USEDEP}]
	<dev-python/typing-extensions-5[${PYTHON_USEDEP}]
	aiohttp? (
		>=dev-python/aiohttp-3.14.4[${PYTHON_USEDEP}]
		>=dev-python/multidict-6.9.1[${PYTHON_USEDEP}]
		>=dev-python/yarl-1.25.1[${PYTHON_USEDEP}]
	)
	bedrock? (
		>=dev-python/botocore-1.40.0[${PYTHON_USEDEP}]
		<dev-python/botocore-2[${PYTHON_USEDEP}]
	)
"

# The project readme is a dynamic metadata field produced by the
# hatch-fancy-pypi-readme build hook; without it the hatchling backend aborts.
BDEPEND="dev-python/hatch-fancy-pypi-readme[${PYTHON_USEDEP}]"

# Nearly the whole suite (everything under tests/api_resources) talks to a
# Prism mock API server that upstream expects on http://127.0.0.1:4010, and
# upstream ships no marker that separates those from the offline tests.
RESTRICT="test"
