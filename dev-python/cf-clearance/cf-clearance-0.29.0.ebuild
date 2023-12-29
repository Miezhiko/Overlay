# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="BPurpose To make a cloudflare v2 challenge pass successfully"
HOMEPAGE="https://github.com/vvanglro/cf-clearance"

LICENSE="Apache-2.0"
SLOT="0"

# just pull same deps as with streamlit
RDEPEND="
	dev-python/GitPython[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/semver[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	dev-python/watchdog[${PYTHON_USEDEP}]
	>=dev-python/altair-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/blinker-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/cachetools-4.0[${PYTHON_USEDEP}]
	>=dev-python/click-7.0[${PYTHON_USEDEP}]
	>=dev-python/importlib-metadata-1.4[${PYTHON_USEDEP}]
	>=dev-python/packaging-14.1[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.21.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-6.2.0[${PYTHON_USEDEP}]
	>=dev-python/pydeck-0.1.0[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.12[${PYTHON_USEDEP}]
	>=dev-python/pyarrow-4.0[${PYTHON_USEDEP}]
	>=dev-python/pympler-0.9[${PYTHON_USEDEP}]
	>=dev-python/requests-2.4[${PYTHON_USEDEP}]
	>=dev-python/rich-10.11.0[${PYTHON_USEDEP}]
	>=dev-python/tornado-5.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-3.10.0.0[${PYTHON_USEDEP}]
	>=dev-python/tzlocal-1.1[${PYTHON_USEDEP}]
	>=dev-python/validators-0.2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/vvanglro/cf-clearance.git"
	EGIT_BRANCH="main"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/vvanglro/cf-clearance/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

python_prepare_all() {
	distutils-r1_python_prepare_all
}
