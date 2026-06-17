# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..14} )

DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Temporary Email"
HOMEPAGE="https://pypi.org/project/xtempmail"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="dev-python/reactivex"
DEPEND="${RDEPEND}"

KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/krypton-byte/xtempmail/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

