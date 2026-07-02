# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 meson vala xdg

DESCRIPTION="Simple GObject game controller library"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libmanette"

EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/libmanette.git"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="doc +introspection +udev +vala test"
RESTRICT="!test? ( test )"
REQUIRED_USE="vala? ( introspection ) doc? ( introspection )"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-libs/glib-2.50:2
	udev? ( dev-libs/libgudev[introspection?] )
	dev-libs/libevdev
	dev-libs/hidapi
	introspection? ( >=dev-libs/gobject-introspection-1.83.2:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( dev-util/gi-docgen )
	vala? (
		$(vala_depend)
		>=dev-lang/vala-0.56.18
	)
	virtual/pkgconfig
"

src_prepare() {
	default
	use vala && vala_setup
}

src_configure() {
	local emesonargs=(
		-Ddemos=false
		$(meson_use test build-tests)
		-Dinstall-tests=false
		$(meson_use doc doc)
		$(meson_use introspection)
		$(meson_use vala vapi)
		$(meson_feature udev gudev)
	)
	meson_src_configure
}
