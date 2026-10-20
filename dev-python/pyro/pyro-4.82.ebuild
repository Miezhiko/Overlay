# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{9..14} )

DISTUTILS_USE_PEP517=setuptools

# Upstream's sdist filename keeps the "Pyro4" capitalization (not normalized
# per PEP 625), and files.pythonhosted.org has no "pypi" thirdpartymirrors
# entry on this system -- mirror://pypi only ever resolves against
# GENTOO_MIRRORS, which doesn't carry non-Gentoo distfiles. Use pypi.eclass
# directly instead, which builds the files.pythonhosted.org URL itself.
PYPI_PN="Pyro4"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Distributed object middleware for Python (RPC)"
HOMEPAGE="https://pypi.org/project/Pyro4/
	https://github.com/irmen/Pyro4"

LICENSE="MIT"
SLOT="4"
KEYWORDS="amd64 ~arm64 ppc x86"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	!dev-python/pyro:0
	>=dev-python/serpent-1.27[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/cloudpickle-1.2.1[${PYTHON_USEDEP}]
		dev-python/dill[${PYTHON_USEDEP}]
		>=dev-python/msgpack-0.4.6[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	# Disable tests requiring network connection.
	rm tests/PyroTests/test_naming.py || die
	sed \
		-e "s/testStartNSfunc/_&/" \
		-i tests/PyroTests/test_naming2.py || die

	sed \
		-e "s/testBroadcast/_&/" \
		-e "s/testGetIP/_&/" \
		-i tests/PyroTests/test_socket.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && HTML_DOCS=( docs/. )
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
