EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

SRC_URI="https://github.com/fastai/fastai/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=">=sci-libs/pytorch-1.6.0
  >=dev-python/nn-0.1.1"
RDEPEND="${DEPEND}"

