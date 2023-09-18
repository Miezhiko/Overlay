# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 desktop xdg

DESCRIPTION="Official ProtonVPN Linux app"
HOMEPAGE="https://protonvpn.com https://github.com/ProtonVPN/linux-app"
SRC_URI="https://github.com/ProtonVPN/linux-app/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"
IUSE="appindicator"
RESTRICT="primaryuri test"

RDEPEND="
	x11-libs/gtk+:3
	net-libs/webkit-gtk:4
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/jaraco-classes[${PYTHON_USEDEP}]
	appindicator? ( dev-libs/libappindicator:3 )
	>=net-vpn/protonvpn-nm-lib-3.14.0[${PYTHON_USEDEP}]
	!net-vpn/protonvpn-cli
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/linux-app-${PV}"

DOCS=( README.md )

src_install() {
	domenu protonvpn.desktop
	doicon -s scalable protonvpn_gui/assets/icons/protonvpn-logo.png
	distutils-r1_src_install
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postinst() {
	xdg_desktop_database_update
	vxdg_icon_cache_update
}
