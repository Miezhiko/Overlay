EAPI=7

PYTHON_COMPAT=( python3_{6..10} )

inherit distutils-r1

SRC_URI="https://github.com/fastai/fastcore/archive/${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Python supercharged for the fastai library"
HOMEPAGE="https://github.com/fastai"
LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=sci-libs/pytorch-1.7.0"
RDEPEND="${DEPEND}"

