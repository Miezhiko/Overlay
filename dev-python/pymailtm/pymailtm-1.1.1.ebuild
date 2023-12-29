# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="command line interface and python web-api wrapper for mail.tm"
HOMEPAGE="https://pypi.org/project/pymailtm"

LICENSE="GPL-3.0"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/CarloDePieri/pymailtm/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

