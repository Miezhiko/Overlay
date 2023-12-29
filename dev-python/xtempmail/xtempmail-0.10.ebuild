# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Temporary Email"
HOMEPAGE="https://pypi.org/project/xtempmail"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="dev-python/reactivex"
DEPEND="${RDEPEND}"

KEYWORDS="~amd64 ~x86"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

