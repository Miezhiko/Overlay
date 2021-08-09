EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Python Promises"
HOMEPAGE="https://pypi.org/project/vine/ https://github.com/celery/vine"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="test"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

