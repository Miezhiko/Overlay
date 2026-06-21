# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 linux-mod-r1

DESCRIPTION="Linux kernel driver for Acer laptop battery health control WMI interface"
HOMEPAGE="https://github.com/frederik-h/acer-wmi-battery"
EGIT_REPO_URI="https://github.com/frederik-h/acer-wmi-battery.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

CONFIG_CHECK="~ACPI_WMI"

pkg_setup() {
	linux-mod-r1_pkg_setup
}

src_compile() {
	local modlist=( "acer-wmi-battery" )
	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install
}
