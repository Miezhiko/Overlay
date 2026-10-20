# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..14} )

DISTUTILS_USE_PEP517=setuptools

inherit bash-completion-r1 distutils-r1 optfeature

DESCRIPTION="Asynchronous task queue/job queue based on distributed message passing"
HOMEPAGE="http://celeryproject.org/ https://pypi.org/project/celery/"
SRC_URI="https://github.com/celery/celery/archive/refs/tags/v${PV}.tar.gz"
S="${WORKDIR}/celery-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="test"

# Dependencies derive from PyPI's info.requires_dist for this exact release
# (the previous ebuild's RDEPEND dated from a much older celery release;
# click-didyoumean, click-repl and click-plugins are now explicit direct
# deps rather than pulled in transitively, and pytz/greenlet are gone from
# the mandatory set).
RDEPEND="
	>=dev-python/kombu-5.6.0[${PYTHON_USEDEP}]
	>=dev-python/billiard-4.2.1[${PYTHON_USEDEP}]
	<dev-python/billiard-5.0.0[${PYTHON_USEDEP}]
	>=dev-python/vine-5.1.0[${PYTHON_USEDEP}]
	<dev-python/vine-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/click-8.1.2[${PYTHON_USEDEP}]
	<dev-python/click-9.0.0[${PYTHON_USEDEP}]
	>=dev-python/click-didyoumean-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/click-repl-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/click-plugins-1.1.1[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.2[${PYTHON_USEDEP}]
	dev-python/tzlocal[${PYTHON_USEDEP}]
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
