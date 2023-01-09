# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="An elegant system resource monitor for the GNOME shell"
HOMEPAGE="https://github.com/fflewddur/tophat"

inherit git-r3
EGIT_REPO_URI="https://github.com/fflewddur/tophat.git"

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

src_compile() {
	glib-compile-schemas "${S}/schemas"
}

src_install() {
	insinto /usr/share/gnome-shell/extensions/tophat@fflewddur.github.io/
	doins -r "${S}"/*
}

pkg_postinst() {
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}
