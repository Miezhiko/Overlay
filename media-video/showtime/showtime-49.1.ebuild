# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson xdg

DESCRIPTION="A modern video player for GNOME"
HOMEPAGE="https://apps.gnome.org/Showtime/"
SRC_URI="https://download.gnome.org/sources/showtime/${PV%.*}/showtime-${PV}.tar.xz"

LICENSE="GPL-3.0-or-later"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-libs/glib-2.76:2
	>=media-libs/gstreamer-1.22:1.0
	>=media-libs/gst-plugins-base-1.22:1.0
	>=gui-libs/gtk-4.15:4
	media-plugins/gst-plugins-rs
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i "s|Gst\.init()|Gst.init([])|" "${S}/showtime/main.py" || die
}

pkg_postinst() {
	xdg_pkg_postinst
	if [[ -d "${EROOT}/usr/share/glib-2.0/schemas" ]]; then
		einfo "Compiling GSettings schemas..."
		glib-compile-schemas "${EROOT}/usr/share/glib-2.0/schemas" || die
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	if [[ -d "${EROOT}/usr/share/glib-2.0/schemas" ]]; then
		einfo "Recompiling GSettings schemas..."
		glib-compile-schemas "${EROOT}/usr/share/glib-2.0/schemas" || die
	fi
}
