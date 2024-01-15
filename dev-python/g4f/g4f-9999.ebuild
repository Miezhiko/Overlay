# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 git-r3

EGIT_REPO_URI="https://github.com/xtekky/gpt4free.git"
EGIT_BRANCH="main"
EGIT_COMMIT="691fac6db61cf91afbe9abe45e8bd3d47f985e01"
SRC_URI=""
KEYWORDS=""

DESCRIPTION="${PN}"
HOMEPAGE="https://github.com/xtekky/gpt4free"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
    dev-python/js2py
	dev-python/execjs
	dev-python/xtempmail
	dev-python/pypasser
	dev-python/Faker
	dev-python/mailgw-temporary-email
	dev-python/retrying
	dev-python/names
	dev-python/random-password-generator
	dev-python/fake-useragent
	dev-python/curl-cffi
	dev-python/tls-client
	dev-python/browser-cookie3
	dev-python/websockets
	dev-python/quickjs
	dev-python/httpx
	dev-python/mmh3
	dev-python/py-arkose-token-generator
	dev-python/asyncstdlib
	dev-python/async_property
	dev-python/undetected-chromedriver
	dev-python/beautifulsoup4
	"
DEPEND="${RDEPEND}"

KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	rm "${S}"/setup.py || die
	cp "${FILESDIR}"/pyproject.toml "${S}"/ || die
	# diesable debug stuff
	sed -i 's|True|False|g' "${S}/g4f/debug.py" || die
}
