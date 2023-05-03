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

MY_PN=tls_client
MY_P="${MY_PN}-${PV}"

KEYWORDS="~amd64 ~x86"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"
