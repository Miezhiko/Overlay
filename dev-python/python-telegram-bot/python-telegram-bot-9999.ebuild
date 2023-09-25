# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Python wrapper of telegram bots API"
HOMEPAGE="https://python-telegram-bot.org https://github.com/python-telegram-bot/python-telegram-bot"

inherit git-r3
EGIT_REPO_URI="https://github.com/python-telegram-bot/python-telegram-bot"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-3"
SLOT="0"
RESTRICT="test"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/PySocks[${PYTHON_USEDEP}]
	dev-python/ujson[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/tornado[${PYTHON_USEDEP}]
"

DEPEND=""

python_prepare_all() {
	# do not make a test flaky report
	sed -i -e '/addopts/d' setup.cfg || die

	# Remove tests files that require network access
	rm -rf tests || die

	distutils-r1_python_prepare_all
}
