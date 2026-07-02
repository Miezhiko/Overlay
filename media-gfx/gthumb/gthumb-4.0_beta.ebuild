# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )
inherit gnome.org gnome2-utils meson python-any-r1 vala xdg

DESCRIPTION="Image viewer and browser for Gnome"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gthumb/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="colord gif heif jpegxl raw svg tiff webp"

RDEPEND="
	>=dev-libs/glib-2.84:2
	>=gui-libs/gtk-4.18.5:4
	>=gui-libs/libadwaita-1.8.0:1
	>=dev-libs/libportal-0.9:=[gtk]
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	media-plugins/gst-plugins-gtk:1.0
	>=media-libs/lcms-2.6:2
	>=media-gfx/exiv2-0.28:=
	>=media-libs/libpng-1.6:0=
	raw? ( >=media-libs/libraw-0.22:= )
	svg? ( >=gnome-base/librsvg-2.34:2 )
	webp? ( >=media-libs/libwebp-0.2.0:= )
	jpegxl? ( >=media-libs/libjxl-0.3.0:= )
	heif? ( >=media-libs/libheif-1.11:= )
	gif? ( >=media-libs/giflib-5.2.0:= )
	colord? (
		>=x11-misc/colord-1.3
		>=media-libs/lcms-2.6:2
	)

	virtual/zlib
	media-libs/libjpeg-turbo:=
	tiff? ( media-libs/tiff:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/appstream-0.14.6
	dev-util/glib-utils
	dev-util/itstool
	app-alternatives/yacc
	app-alternatives/lex
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	$(vala_depend)
"

src_prepare() {
	default
	vala_setup

	# include stdbool.h globally for bool return types
	sed -i "/'-DLOCALEDIR/i\\  '-include',\\
  'stdbool.h'," meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_use colord)
		$(meson_use webp libwebp)
		$(meson_use svg librsvg)
		$(meson_use heif libheif)
		$(meson_use jpegxl libjxl)
		$(meson_use tiff libtiff)
		$(meson_use gif libgif)
		$(meson_use raw libraw)
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
