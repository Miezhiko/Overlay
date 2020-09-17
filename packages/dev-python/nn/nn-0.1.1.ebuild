EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

SRC_URI="https://files.pythonhosted.org/packages/b3/2a/b00995cba3fda79210c0002355925b45a3abf882c2b3c42b5275dc6708df/nn-0.1.1.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="${DEPEND}"

