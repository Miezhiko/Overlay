# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 gnome2-utils meson vala xdg

DESCRIPTION="A game emulator for GNOME (formerly gnome-games)"
HOMEPAGE="https://gitlab.gnome.org/World/highscore"

EGIT_REPO_URI="https://gitlab.gnome.org/World/highscore.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-arch/libarchive:=
	>=dev-db/sqlite-3:3
	>=dev-libs/feedbackd-0.6.0:=
	>=dev-libs/glib-2.74:2
	dev-libs/json-glib
	>=dev-libs/libgee-0.8:0.8
	>=dev-libs/libhighscore-0.1.0:=
	>=dev-libs/libmanette-1.0_alpha:=
	>=dev-libs/libmirage-3.3.2:=
	>=gnome-base/librsvg-2:2
	>=gui-libs/gtk-4.21.2:4
	>=gui-libs/libadwaita-1.9_alpha:1
	>=media-libs/glycin-2
	media-libs/libepoxy
	media-libs/libglvnd
	media-libs/libpulse
	media-libs/mesa
	media-libs/vulkan-loader
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(vala_depend)
	dev-util/blueprint-compiler
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	default
	vala_setup
}

src_configure() {
	local emesonargs=(
		-Dprofile=default
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
