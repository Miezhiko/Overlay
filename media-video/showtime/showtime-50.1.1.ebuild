# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson xdg

DESCRIPTION="A modern video player for GNOME"
HOMEPAGE="https://apps.gnome.org/Showtime/"

SRC_URI="https://gitlab.gnome.org/GNOME/showtime/-/archive/${PV}/showtime-${PV}.tar.bz2;downloadfilename=showtime-${PV}.tar.bz2"

LICENSE="GPL-3.0-or-later"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="
	>=dev-libs/glib-2.76:2
	>=media-libs/gstreamer-1.22:1.0
	>=media-libs/gst-plugins-base-1.22:1.0
	>=gui-libs/gtk-4.15:4
	media-plugins/gst-plugins-rs
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/showtime-50.1.1-c73f7956d6353db85d0981d680d2644e3c16e158"

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
