EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit distutils-r1

SRC_URI="https://github.com/fastai/fastai/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="2"
KEYWORDS="amd64 x86"

DEPEND=">=sci-libs/pytorch-1.7.0"
RDEPEND="${DEPEND}"

