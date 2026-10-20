# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..14} )

DISTUTILS_USE_PEP517=setuptools

# files.pythonhosted.org has no "pypi" thirdpartymirrors entry on this
# system -- mirror://pypi only ever resolves against GENTOO_MIRRORS, which
# doesn't carry non-Gentoo distfiles. Use pypi.eclass directly instead,
# which builds the files.pythonhosted.org URL itself. This also drops the
# old S= override for the pre-standalone-repo monorepo tarball layout
# (packages/google-cloud-translate/ subdirectory); the current sdist is a
# normal, flat, standalone-package tarball.
inherit distutils-r1 pypi

DESCRIPTION="${PN}"
HOMEPAGE="https://pypi.org/project/${PN}"

LICENSE="GPL-3.0"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

KEYWORDS="~amd64 ~x86"

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}
