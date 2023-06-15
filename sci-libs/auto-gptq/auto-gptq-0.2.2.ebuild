# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="An easy-to-use LLMs quantization package with user-friendly apis, based on GPTQ algorithm."
HOMEPAGE="https://pypi.org/project/auto-gptq/"
SRC_URI="https://github.com/PanQiWei/AutoGPTQ/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"
S="${WORKDIR}/AutoGPTQ-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test" # Need some modules, not yet packaged

RDEPEND="
	dev-python/filelock[${PYTHON_USEDEP}]
	sci-libs/huggingface_hub[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	sci-libs/tokenizers[${PYTHON_USEDEP}]
	sci-libs/transformers[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
