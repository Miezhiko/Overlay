EAPI=7

PYTHON_COMPAT=( python3_{6..10} )

inherit distutils-r1

SRC_URI="https://github.com/fastai/fastai/archive/${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="The fastai deep learning library"
HOMEPAGE="https://github.com/fastai"
LICENSE="Apache-2.0"

SLOT="2"
KEYWORDS="~amd64"

DEPEND="
  dev-python/fastprogress  
  >=dev-python/fastcore-1.3.27"
RDEPEND="${DEPEND}"

