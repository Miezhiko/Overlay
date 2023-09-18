# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Official ProtonVPN Linux app (CLI)"
HOMEPAGE="https://protonvpn.com https://github.com/ProtonVPN/linux-cli"
SRC_URI="https://github.com/ProtonVPN/linux-cli/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"
IUSE="systemd"
RESTRICT="test primaryuri" # only has dummy tests anyway

RDEPEND="
	!net-vpn/protonvpn-gui
	dev-python/pythondialog[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	>=net-vpn/protonvpn-nm-lib-3.13.0[${PYTHON_USEDEP}]
	systemd? ( dev-python/python-systemd[${PYTHON_USEDEP}] )
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/linux-cli-${PV}"

DOCS=( README.md )
