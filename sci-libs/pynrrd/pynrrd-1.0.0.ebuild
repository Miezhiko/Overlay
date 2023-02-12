# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{7..11} )

inherit distutils-r1

DESCRIPTION="pure-Python module for reading and writing NRRD files into and from numpy arrays"
HOMEPAGE="https://pypi.org/project/pynrrd"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

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

