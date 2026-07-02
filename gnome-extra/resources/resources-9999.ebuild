# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.92.0"
inherit cargo git-r3 gnome2-utils meson xdg

DESCRIPTION="A system resources monitor for GNOME"
HOMEPAGE="https://apps.gnome.org/app/org.gnome.Resources/ https://gitlab.gnome.org/GNOME/Incubator/resources"

EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/Incubator/resources.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=gui-libs/gtk-4.12:4
	>=gui-libs/libadwaita-1.8:1
	>=dev-libs/glib-2.66:2
	sys-auth/polkit
"
DEPEND="${RDEPEND}"
BDEPEND="
	${RUST_DEPEND}
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_prepare() {
	default
	sed -i "/CARGO_HOME/d" src/meson.build || die
}

src_configure() {
	local emesonargs=(
		-Dprofile=release
		-Ddevelopment_build=false
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
