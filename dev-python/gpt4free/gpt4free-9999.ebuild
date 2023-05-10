# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 git-r3

EGIT_REPO_URI="https://github.com/xtekky/gpt4free.git"
EGIT_BRANCH="main"
SRC_URI=""
KEYWORDS=""

DESCRIPTION="${PN}"
HOMEPAGE="https://pypi.org/project/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/streamlit
	dev-python/fake-useragent
	dev-python/curl-cffi
	dev-python/random-username
	dev-python/tls-client
	dev-python/xtempmail
	dev-python/pypasser
	dev-python/Faker
	dev-python/mailgw-temporary-email"
DEPEND="${RDEPEND}"

KEYWORDS="~amd64 ~x86"

