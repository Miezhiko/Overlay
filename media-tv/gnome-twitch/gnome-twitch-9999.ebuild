# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils meson xdg git-r3

DESCRIPTION="Gnome Twitch"
HOMEPAGE="https://github.com/vinszent/gnome-twitch"
EGIT_REPO_URI="https://github.com/vinszent/gnome-twitch.git"
EGIT_BRANCH="master"
LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-libs/glib-2.50:2
	>=dev-libs/gobject-introspection-1.54:=
	>=x11-libs/gtk+-3.24.7:3[introspection]
	net-libs/libsoup:2.4[introspection]
"

RDEPEND="${DEPEND}
	media-libs/gstreamer:1.0[introspection]
	media-libs/gst-plugins-base:1.0[introspection]
	media-plugins/gst-plugins-meta:1.0
"
BDEPEND="
	dev-libs/libxml2:2
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	xdg_src_prepare
}

src_install() {
	meson_src_install
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
