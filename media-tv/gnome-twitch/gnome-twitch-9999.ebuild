# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils xdg git-r3 meson

DESCRIPTION="Gnome Twitch"
HOMEPAGE="https://github.com/vinszent/gnome-twitch"
EGIT_REPO_URI="https://github.com/vinszent/gnome-twitch.git"
EGIT_BRANCH="master"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+gst-cairo gst-opengl gst-clutter mpv"

DEPEND=">=dev-util/meson-0.32.0
		dev-util/ninja"
RDEPEND="${DEPEND}
		>=x11-libs/gtk+-3.20
		net-libs/libsoup
		dev-libs/json-glib
		net-libs/webkit-gtk
		gst-cairo? (
			media-libs/gstreamer
			media-plugins/gst-plugins-libav
			media-libs/gst-plugins-base
			media-libs/gst-plugins-good
			media-libs/gst-plugins-bad
		)
		gst-opengl? (
			media-libs/gstreamer
			media-plugins/gst-plugins-libav
			media-libs/gst-plugins-base
			media-libs/gst-plugins-good
			media-libs/gst-plugins-bad
		)
		gst-clutter? (
			media-libs/gstreamer
			media-plugins/gst-plugins-libav
			media-libs/gst-plugins-base
			media-libs/gst-plugins-good
			media-libs/gst-plugins-bad
			>=media-libs/clutter-gst-3.0
			>=media-libs/clutter-gtk-1.0
		)
		mpv? (
			media-video/mpv[libmpv]
		)
		dev-libs/libpeas
		dev-libs/gobject-introspection"

src_configure() {
	local backends

	if use gst-cairo ; then
		backends+=("gstreamer-cairo")
	fi
	if use gst-opengl ; then
		backends+=("gstreamer-opengl")
	fi
	if use gst-clutter ; then
		backends+=("gstreamer-clutter")
	fi
	if use mpv ; then
		backends+=("mpv-opengl")
	fi
	local emesonargs=(
		-Dbuild-player-backends=${local}
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
