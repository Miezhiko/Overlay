# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..13} )

DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 git-r3

DESCRIPTION="${PN}"
HOMEPAGE="https://pypi.org/project/${PN}"

LICENSE="GPL-3.0"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

KEYWORDS="~amd64 ~x86"
EGIT_REPO_URI="https://github.com/williexu/random_username.git"
RESTRIC="mirror"
