# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 git-r3

EGIT_REPO_URI="https://github.com/ading2210/poe-api.git"
EGIT_BRANCH="main"
SRC_URI=""
KEYWORDS=""

DESCRIPTION="A reverse engineered Python API wrapper for Quora's Poe"
HOMEPAGE="https://github.com/ading2210/poe-api"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/fake-useragent
	dev-python/curl-cffi
	dev-python/tls-client"
DEPEND="${RDEPEND}"

KEYWORDS="~amd64 ~x86"
