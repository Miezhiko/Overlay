# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 git-r3

EGIT_REPO_URI="https://gitler.moe/g4f/gpt4free.git"
EGIT_BRANCH="main"
SRC_URI=""
KEYWORDS=""

DESCRIPTION="${PN}"
HOMEPAGE="https://gitler.moe/g4f/gpt4free"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/fake-useragent
	dev-python/curl-cffi
	dev-python/tls-client
	dev-python/browser-cookie3"
DEPEND="${RDEPEND}"

KEYWORDS="~amd64 ~x86"

src_prepare() {
	default

	cp "${FILESDIR}/pyproject.toml" "${S}"/ || die "Failed to add pyproject"
}
