# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Proton account login backend"
HOMEPAGE="https://protonvpn.com https://protonmail.com https://github.com/ProtonMail/proton-python-client"
SRC_URI="https://github.com/ProtonMail/proton-python-client/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"
RESTRICT="primaryuri test"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/bcrypt[${PYTHON_USEDEP}]
	dev-python/python-gnupg[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/proton-python-client-${PV}"

DOCS=( README.md )

distutils_enable_tests unittest
