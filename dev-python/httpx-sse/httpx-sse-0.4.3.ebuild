# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Consume Server-Sent Event (SSE) messages with HTTPX"
HOMEPAGE="https://github.com/florimondmanca/httpx-sse"
SRC_URI="https://files.pythonhosted.org/packages/0f/4c/751061ffa58615a32c31b2d82e8482be8dd4a89154f003147acee90f2be9/httpx_sse-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

RDEPEND="
	dev-python/httpx[${PYTHON_USEDEP}]
"

S="${WORKDIR}/httpx_sse-${PV}"
