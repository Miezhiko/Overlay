# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo gnome.org meson xdg git-r3

DESCRIPTION="A simple, modern image viewer for GNOME"
HOMEPAGE="https://apps.gnome.org/Loupe/"
SRC_URI=""
EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/loupe.git"
EGIT_COMMIT="50.0"

LICENSE="GPL-3.0-or-later"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

QA_FLAGS_IGNORED="usr/bin/loupe"

DEPEND="
	>=dev-libs/glib-2.76:2
	>=gui-libs/gtk-4.12:4
	>=x11-libs/gdk-pixbuf-2.42:2
	>=media-libs/glycin-0.3
"
RDEPEND="${DEPEND}"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_prepare() {
	default
}

src_configure() {
	local emesonargs=(
		$(meson_feature X x11)
	)
	meson_src_configure
	ln -s "${CARGO_HOME}" "${BUILD_DIR}/cargo-home" || die
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
