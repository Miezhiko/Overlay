# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..13} )

DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="${PN}"
HOMEPAGE="https://pypi.org/project/${PN}"

LICENSE="GPL-3.0"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

KEYWORDS="~amd64 ~x86"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

S="${WORKDIR}/google-cloud-python-google-cloud-translate-v${PV}/packages/google-cloud-translate"

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}
