EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Python multiprocessing fork"
HOMEPAGE="https://pypi.org/project/billiard/ https://github.com/celery/billiard"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="test"

DEPEND=">=dev-python/setuptools-20.6.7[${PYTHON_USEDEP}]"
