# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="pure-Python module for reading and writing NRRD files into and from numpy arrays"
HOMEPAGE="https://pypi.org/project/pynrrd"
SRC_URI="https://github.com/mhe/pynrrd/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# just it wasn't yet tested, so to be sure
RESTRICT="test"

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/nptyping[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

