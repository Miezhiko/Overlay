EAPI=7
PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

MY_PN="amqp"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Low-level AMQP client for Python (fork of amqplib)"
HOMEPAGE="https://github.com/celery/py-amqp https://pypi.org/project/amqp/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="extras"
RESTRICT="test"

DEPEND="
  dev-python/setuptools[${PYTHON_USEDEP}]
  >=dev-python/vine-5.0.0[${PYTHON_USEDEP}]
"

python_prepare_all() {
  # pytest-sugar is not packaged
  sed -e '/pytest-sugar/d' -i requirements/test.txt || die

  # requires a rabbitmq instance
  rm t/integration/test_rmq.py || die

  distutils-r1_python_prepare_all
}

python_install_all() {
  if use extras; then
    insinto /usr/share/${PF}/extras
    doins -r extra
  fi
  distutils-r1_python_install_all
}
