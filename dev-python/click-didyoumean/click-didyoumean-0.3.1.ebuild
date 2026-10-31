# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..15} )
DISTUTILS_USE_PEP517=poetry

inherit distutils-r1 pypi

DESCRIPTION="Enables git-like did-you-mean feature in click"
HOMEPAGE="https://github.com/click-contrib/click-didyoumean"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/click-7[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

RESTRICT="test"
