# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="New email notification icon for GNOME Shell."
HOMEPAGE="https://github.com/Qeenon/new-mail-indicator"

inherit git-r3
EGIT_REPO_URI="https://github.com/Qeenon/new-mail-indicator.git"

LICENSE="GPL-3"
RESTRICT="mirror test"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/glib"
RDEPEND="${DEPEND}
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-40.0
"
BDEPEND=""

src_compile() { :; }

src_install() {
	insinto /usr/share/gnome-shell/extensions/new-mail-indicator@fthx/
	doins -r "${S}"/*
}

pkg_postinst() {
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}
