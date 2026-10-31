# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..15} )

inherit distutils-r1

DESCRIPTION="Build and share machine learning and data science web apps"
HOMEPAGE="https://streamlit.io"

LICENSE="Apache-2.0"
SLOT="0"

# Dependencies derive from PyPI's info.requires_dist for this exact release
# (the old ebuild's RDEPEND dated from 1.22.0; between then and 1.66.0
# upstream dropped Tornado for a Starlette+Uvicorn backend, which pulls in
# a mostly different dependency set -- GitPython, python-dateutil, semver,
# toml, validators, blinker, cachetools, importlib-metadata, pympler,
# tornado and tzlocal are gone; starlette, uvicorn, anyio,
# python-multipart, websockets and itsdangerous are new).
#
# Note that:
# * Streamlit tarballs currently contain *NO* documentation or tests. /shrug/
# * Streamlit itself is housed under the "lib/" subdirectory of the official
#   Streamlit GitHub repository at:
#       https://github.com/streamlit/streamlit/tree/develop/lib
RDEPEND="
	>=dev-python/altair-5.0.0[${PYTHON_USEDEP}]
	>=dev-python/anyio-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/click-7.0[${PYTHON_USEDEP}]
	>=dev-python/itsdangerous-2.1.2[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.25.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-20[${PYTHON_USEDEP}]
	>=dev-python/pandas-1.5.3[${PYTHON_USEDEP}]
	>=dev-python/pillow-9.2.0[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-5.26.1[${PYTHON_USEDEP}]
	>=dev-python/pyarrow-10.0.1[${PYTHON_USEDEP}]
	>=dev-python/pydeck-0.8[${PYTHON_USEDEP}]
	>=dev-python/python-multipart-0.0.10[${PYTHON_USEDEP}]
	>=dev-python/requests-2.27[${PYTHON_USEDEP}]
	>=dev-python/starlette-0.46.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.10.0[${PYTHON_USEDEP}]
	>=dev-python/uvicorn-0.30.0[${PYTHON_USEDEP}]
	>=dev-python/watchdog-2.1.5[${PYTHON_USEDEP}]
	>=dev-python/websockets-12.0.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

#FIXME: Enable pytest-based testing after Streamlit tarballs begin bundling
#tests. Since the Streamlit GitHub repository currently contains tests, it's
#likely their tarballs will begin bundling tests... at some point.
# distutils_enable_tests pytest

if [[ ${PV} == 9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/streamlit/streamlit.git"
	EGIT_BRANCH="master"
	SRC_URI=""
	KEYWORDS=""
else
	# files.pythonhosted.org has no "pypi" thirdpartymirrors entry on this
	# system -- mirror://pypi only ever resolves against GENTOO_MIRRORS,
	# which doesn't carry non-Gentoo distfiles. Use pypi.eclass directly
	# instead, which builds the files.pythonhosted.org URL itself.
	inherit pypi
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

python_prepare_all() {
	# Prevent "setup.py" from installing Windows-specific executables.
	sed -i -e '/streamlit\.cmd/d' setup.py || die

	distutils-r1_python_prepare_all
}
