# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Note that a live git-managed "9999" version is intentionally *NOT* provided.
# This Python package is embedded in a larger JavaScript "deck.gl" package,
# significantly complicating installation from the GitHub repository. See also:
#     https://github.com/visgl/deck.gl/tree/master/bindings/pydeck

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..15} )

# files.pythonhosted.org has no "pypi" thirdpartymirrors entry on this
# system -- mirror://pypi only ever resolves against GENTOO_MIRRORS, which
# doesn't carry non-Gentoo distfiles. Use pypi.eclass directly instead,
# which builds the files.pythonhosted.org URL itself.
inherit distutils-r1 pypi

DESCRIPTION="Large-scale interactive data visualization"
HOMEPAGE="https://pydeck.gl"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

# Dependencies derive from the "setup.py".
#
# Note that Jinja2 appears to be required at build time, oddly. *shrug*
BDEPEND="
	>=dev-python/jinja2-2.10.1[${PYTHON_USEDEP}]
	test? (
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		>=dev-python/pytest-4.0.2[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	>=dev-python/ipykernel-5.1.2[${PYTHON_USEDEP}]
	>=dev-python/ipywidgets-7.0.0[${PYTHON_USEDEP}]
	>=dev-python/jinja2-2.10.1[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.16.4[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.3.2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

python_prepare_all() {
	# Delete the line in "setup.py" erroneously installing a pydeck-specific
	# configuration file to the non-standard "/usr/etc/" directory.
	sed -i -e '\~"etc/jupyter/nbconfig/notebook.d"~d' setup.py ||
		die '"sed" failed.'

	distutils-r1_python_prepare_all
}

python_install_all() {
	[[ -d examples ]] && dodoc -r examples

	# Install the pydeck-specific configuration file to the standard "/etc/"
	# directory. See the related "sed" patch above.
	insinto /etc/jupyter/nbconfig/notebook.d
	doins pydeck.json

	distutils-r1_python_install_all
}
