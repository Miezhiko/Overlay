EAPI=7

PYTHON_COMPAT=( python3_{6..10} )

inherit distutils-r1

SRC_URI="https://files.pythonhosted.org/packages/66/56/2e658d6d310bb2f7890ae066964e5ef3330cb203914ea0609036b614b123/fastprogress-1.0.0.tar.gz -> ${P}.tar.gz"
DESCRIPTION="progress lib for fastai"
HOMEPAGE="https://github.com/fastai"

SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="${DEPEND}"

