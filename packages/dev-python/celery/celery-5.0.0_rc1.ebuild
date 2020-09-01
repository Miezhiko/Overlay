EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit bash-completion-r1 distutils-r1 eutils

DESCRIPTION="Asynchronous task queue/job queue based on distributed message passing"
HOMEPAGE="http://celeryproject.org/ https://pypi.org/project/celery/"
SRC_URI="https://github.com/celery/celery/archive/v5.0.0rc1.tar.gz"
S="${WORKDIR}/celery-5.0.0rc1"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"
IUSE=""
RESTRICT="test"

RDEPEND="
  >=dev-python/kombu-5.0.0[${PYTHON_USEDEP}]
  >=dev-python/billiard-3.6.3[${PYTHON_USEDEP}]
  <dev-python/billiard-4.0.0[${PYTHON_USEDEP}]
  dev-python/pytz[${PYTHON_USEDEP}]
  dev-python/greenlet[${PYTHON_USEDEP}]
  >=dev-python/vine-1.3.0[${PYTHON_USEDEP}]
  >=dev-python/click-repl-0.1.6[${PYTHON_USEDEP}]
  >=dev-python/click-didyoumean-0.0.3[${PYTHON_USEDEP}]
  >=net-misc/rabbitmq-server-3.8.7
"

DEPEND="
  dev-python/setuptools[${PYTHON_USEDEP}]
"

# testsuite needs it own source
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
  distutils-r1_python_prepare_all
}

python_install_all() {
  # Main celeryd init.d and conf.d
  newinitd "${FILESDIR}/celery.initd-r2" celery
  newconfd "${FILESDIR}/celery.confd-r2" celery

  newbashcomp extra/bash-completion/celery.bash ${PN}
  distutils-r1_python_install_all
}

pkg_postinst() {
  optfeature "zookeeper support" dev-python/kazoo
  optfeature "msgpack support" dev-python/msgpack
  optfeature "rabbitmq support" net-misc/rabbitmq-server
  optfeature "slmq support" dev-python/softlayer_messaging
  optfeature "eventlet support" dev-python/eventlet
  optfeature "couchbase support" dev-python/couchbase
  optfeature "redis support" dev-db/redis dev-python/redis-py
  optfeature "gevent support" dev-python/gevent
  optfeature "auth support" dev-python/pyopenssl
  optfeature "pyro support" dev-python/pyro:4
  optfeature "yaml support" dev-python/pyyaml
  optfeature "memcache support" dev-python/pylibmc
  optfeature "mongodb support" dev-python/pymongo
  optfeature "sqlalchemy support" dev-python/sqlalchemy
  optfeature "sqs support" dev-python/boto
  optfeature "cassandra support" dev-python/cassandra-driver
}
