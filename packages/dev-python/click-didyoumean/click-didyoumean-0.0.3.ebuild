EAPI=7

PYTHON_COMPAT=( python{3_6,3_7} )
inherit distutils-r1

DESCRIPTION="Enable git-like did-you-mean feature in click."
HOMEPAGE="https://github.com/click-contrib/click-didyoumean"
SRC_URI="https://github.com/click-contrib/click-didyoumean/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
DEPEND="dev-python/click[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
