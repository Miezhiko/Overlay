# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils meson xdg-utils

DESCRIPTION="Matrix messaging app for GNOME written in Rust"
HOMEPAGE="https://wiki.gnome.org/Apps/Fractal"

# fractal frequently uses unreleased versions of crates
# They provide a tar with these crates vendored for released versions of fractal
if [[ ${PV} == 9999 ]]
then
	inherit cargo git-r3
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/fractal"

	src_unpack() {
		git-r3_src_unpack
		cargo_live_src_unpack
	}

	src_compile() {
		export CARGO_HOME="${ECARGO_HOME}"
		meson_src_compile
	}
else
	SRC_URI="https://gitlab.gnome.org/GNOME/fractal/uploads/46141d42ea313ecce83c8843f96d2c42/fractal-4.4.1.tar.xz -> ${P}.tar.xz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-4.4.1"

	PATCHES+=(
		"${FILESDIR}/meson.patch"
	)
fi

RESTRICT="network-sandbox"

LICENSE="GPL-3+"
SLOT="0"
IUSE="debug"

RDEPEND="
	app-text/gspell
	dev-libs/glib
	dev-libs/openssl
	gui-libs/libhandy:1
	media-libs/gst-plugins-bad
	media-libs/gst-plugins-base
	media-libs/gstreamer
	media-libs/gstreamer-editing-services
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/gtksourceview:4
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	# remove deny! macro
	sed -i '1d' "${S}"/fractal-gtk/src/main.rs || die
}

src_configure() {
	local emesonargs=(
		-Dprofile=$(usex debug 'development' 'default')
	)
	meson_src_configure
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_icon_cache_update
}
