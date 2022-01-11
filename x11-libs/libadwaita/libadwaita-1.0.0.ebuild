# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND=vapigen

inherit vala meson xdg

COMMIT="73df8970af91b8c6ed5da0e31655690256a6c4da"

DESCRIPTION="Building blocks for modern GNOME applications."
HOMEPAGE="https://gitlab.gnome.org/GNOME/libadwaita"
SRC_URI="https://gitlab.gnome.org/GNOME/libadwaita/-/archive/${COMMIT}/libadwaita-${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/$PN-${COMMIT}"

LICENSE="GPL-3"
SLOT="0"
IUSE="examples gtk-doc inspector +introspection vala"
REQUIRED_USE="vala? ( introspection ) gtk-doc? ( introspection )"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/fribidi
	dev-libs/glib
	>=gui-libs/gtk-4.5.1:4[introspection?]
	introspection? ( dev-libs/gobject-introspection )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/sassc
	gtk-doc? ( dev-util/gi-docgen )
	vala? ( $(vala_depend) )
"

src_prepare() {
	default
	use vala && vala_src_prepare
	if use gtk-doc
	then sed -i "s/libadwaita-@0@'.format(apiversion)/${PF}'/" doc/meson.build || die
	fi
}

src_configure() {
	local emesonargs=(
		$(meson_use examples)
		$(meson_use gtk-doc gtk_doc)
		$(meson_use inspector)
		$(meson_feature introspection)
		$(meson_use vala vapi)
	)
	meson_src_configure
}
