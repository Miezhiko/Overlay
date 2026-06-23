# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=1
CRATES=" "

inherit gnome.org meson xdg cargo

DESCRIPTION="A webcam app for gnome"
HOMEPAGE="https://apps.gnome.org/Snapshot/"

SRC_URI="https://download.gnome.org/sources/snapshot/${PV%.*}/snapshot-${PV}.tar.xz"

LICENSE="GPL-3.0-or-later"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-libs/glib-2.76:2
	>=media-libs/gstreamer-1.22:1.0
	>=media-libs/gst-plugins-base-1.22:1.0
	>=media-libs/gst-plugins-bad-1.22:1.0
	>=gui-libs/gtk-4.15:4
	>=media-libs/glycin-2
	>=media-libs/glycin-gtk4-2
	media-plugins/gst-plugins-rs
	media-libs/lcms2:2
	sys-libs/libseccomp
"
RDEPEND="${DEPEND}
	media-video/pipewire[gstreamer]
"

src_configure() {
	meson_src_configure

	local cargo_home="${BUILD_DIR}/cargo-home"
	mkdir -p "${cargo_home}" || die
	cat > "${cargo_home}/config.toml" <<-EOF || die "Failed to create cargo config"
	[source.crates-io]
	replace-with = "vendored-sources"

	[source.vendored-sources]
	directory = "${S}/vendor"

	[net]
	offline = true

	[profile.release]
	lto = false
	EOF
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
