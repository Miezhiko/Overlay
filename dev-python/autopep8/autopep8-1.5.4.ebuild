EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~alpha amd64 ~arm64 ~ia64 ~ppc ~sparc x86 ~amd64-linux ~x86-linux"

LICENSE="MIT"
SLOT="0"

RESTRICT="test"

RDEPEND=">=dev-python/pycodestyle-2.4.0[${PYTHON_USEDEP}]"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

distutils_enable_tests setup.py
