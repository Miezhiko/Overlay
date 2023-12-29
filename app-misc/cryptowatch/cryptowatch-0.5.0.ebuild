# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="fast & furious"
HOMEPAGE="https://cryptowat.ch"
SRC_URI="https://dist-native.cryptowat.ch/${PV}/${PN}-x86_64-unknown-linux-gnu.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

S=${WORKDIR}

inherit desktop

src_install() {
	domenu "${FILESDIR}"/${PN}.desktop
	newbin cryptowatch_desktop cryptowatch
}
