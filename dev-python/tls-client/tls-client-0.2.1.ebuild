# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="ython-TLS-Client is an advanced HTTP library based on requests and tls-client."
HOMEPAGE="https://pypi.org/project/tls-client/"

LICENSE="GPL-3.0"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

KEYWORDS="~amd64"
SRC_URI="https://github.com/FlorianREGAZ/Python-Tls-Client/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/Python-Tls-Client-${PV}"

src_install() {
	insinto /usr/lib64
	doins "${S}/tls_client/dependencies/tls-client-amd64.so"
	distutils-r1_src_install
}
