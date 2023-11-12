# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1 git-r3

EGIT_REPO_URI="https://github.com/ryananguiano/async_property.git"
EGIT_BRANCH="master"
SRC_URI=""
KEYWORDS=""

DESCRIPTION="Python decorator for async properties"
HOMEPAGE="https://github.com/ryananguiano/async_property"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

KEYWORDS="~amd64 ~x86"

