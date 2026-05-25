# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )
DISTUTILS_USE_PEP517=pdm-backend

inherit distutils-r1

DESCRIPTION="Agent Client Protocol"
HOMEPAGE="https://github.com/agentclientprotocol/python-sdk"
SRC_URI="https://github.com/agentclientprotocol/python-sdk/archive/refs/tags/${PV/_alpha/a}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/python-sdk-${PV/_alpha/a}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

RDEPEND="
	dev-python/pydantic[${PYTHON_USEDEP}]
"
