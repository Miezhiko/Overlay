# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 meson vala

DESCRIPTION="A shared library for Highscore cores"
HOMEPAGE="https://gitlab.gnome.org/alicem/libhighscore"

EGIT_REPO_URI="https://gitlab.gnome.org/alicem/libhighscore.git"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc +introspection test +vapi"
RESTRICT="!test? ( test )"
REQUIRED_USE="vapi? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.76:2
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2 )
	$(vala_depend)
"

src_prepare() {
	default
	vala_setup
}

src_configure() {
	local emesonargs=(
		$(meson_feature introspection)
		$(meson_use vapi)
		$(meson_use doc documentation)
		$(meson_use test tests)
	)
	meson_src_configure
}
