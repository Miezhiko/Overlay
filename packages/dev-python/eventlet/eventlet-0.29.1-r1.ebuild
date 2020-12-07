EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="Highly concurrent networking library"
HOMEPAGE="https://pypi.org/project/eventlet/ https://github.com/eventlet/eventlet/"
SRC_URI="mirror://pypi/e/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""
RESTRICT="test"

RDEPEND="
  >=dev-python/dnspython-1.15.0[${PYTHON_USEDEP}]
  <dev-python/dnspython-2.0.0[${PYTHON_USEDEP}]
  >=dev-python/greenlet-0.3[${PYTHON_USEDEP}]
  >=dev-python/monotonic-1.4[${PYTHON_USEDEP}]
  >=dev-python/six-1.10.0[${PYTHON_USEDEP}]"
DEPEND=""

PATCHES=(
  "${FILESDIR}/eventlet-0.25.1-tests.patch"
  "${FILESDIR}/${P}-tests.patch"
)

python_prepare_all() {
  # Prevent file collisions from teestsuite
  sed -e "s:'tests', :'tests', 'tests.*', :" -i setup.py || die

  distutils-r1_python_prepare_all
}

python_test() {
  unset PYTHONPATH
  nosetests -v || die
}

python_install_all() {
  distutils-r1_python_install_all
}

