EAPI=7
PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="AMQP Messaging Framework for Python"
HOMEPAGE="https://pypi.org/project/kombu/ https://github.com/celery/kombu"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"
IUSE="mongodb msgpack redis sqs yaml"
RESTRICT="test"

RDEPEND="
  >=dev-python/importlib_metadata-0.18[${PYTHON_USEDEP}]
  >=dev-python/py-amqp-2.6[${PYTHON_USEDEP}]
  >=dev-python/pyro-4.76:4[${PYTHON_USEDEP}]
  sqs? ( >=dev-python/boto3-1.4.4[${PYTHON_USEDEP}] )
  msgpack? ( >=dev-python/msgpack-0.3.0[${PYTHON_USEDEP}] )
  mongodb? ( >=dev-python/pymongo-3.3.0[${PYTHON_USEDEP}] )
  redis? ( >=dev-python/redis-py-3.3.11[${PYTHON_USEDEP}] )
  yaml? ( >=dev-python/pyyaml-3.10[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
  >=dev-python/setuptools-20.6.7[${PYTHON_USEDEP}]"

python_prepare_all() {
  # AttributeError: test_Etcd instance has no attribute 'patch'
  rm t/unit/transport/test_etcd.py || die
  # allow use of new (renamed) msgpack
  sed -i '/msgpack/d' requirements/extras/msgpack.txt || die
  # pytest-sugar is not packaged
  sed -i '/pytest-sugar/d' requirements/test.txt || die
  distutils-r1_python_prepare_all
}

