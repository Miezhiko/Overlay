EAPI=7

PYTHON_COMPAT=( python3_9 )

inherit distutils-r1

DESCRIPTION="Subcommand REPL for click apps"
HOMEPAGE="https://github.com/click-contrib/click-repl https://pypi.python.org/pypi/click-repl"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-python/click[${PYTHON_USEDEP}]
  dev-python/prompt_toolkit[${PYTHON_USEDEP}]
  dev-python/six[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

DOCS=( README.rst )
