# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.81"

inherit cargo gnome.org gnome2 meson xdg git-r3

DESCRIPTION="A document viewer for the GNOME desktop"
HOMEPAGE="https://apps.gnome.org/Papers/"

SRC_URI=""
EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/${PN}.git"
EGIT_COMMIT="50.beta"

LICENSE="GPL-2+ MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD MIT Unicode-3.0 ZLIB
"

# subslot = ppsd4.0.(suffix of libppsdocument-4.0)-ppsv4.0.(suffix of libppsview-4.0)
SLOT="0/ppsd4.0.5-ppsv4.0.4"

KEYWORDS="~amd64"

IUSE="+comics djvu doc gnome-keyring introspection nautilus +spell sysprof
test tiff"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	dev-libs/appstream-glib
	doc? ( dev-util/gi-docgen )
"

# sys-crates in pycargoebuild order
DEPEND="
	x11-libs/cairo
	x11-libs/gdk-pixbuf[introspection?]
	sys-devel/gettext
	media-libs/graphene
	media-libs/libraw
	x11-libs/pango[introspection?]
"
# meson.build file
DEPEND+="
	>=dev-libs/glib-2.75.0:2
	>=gui-libs/gtk-4.17.1:4
	>=gui-libs/libadwaita-1.6:1
	media-libs/exempi:2
	>=x11-libs/cairo-1.14.0
	sys-libs/zlib

	sysprof? ( dev-util/sysprof-capture:4 )

	nautilus? ( >=gnome-base/nautilus-43 )
	introspection? ( dev-libs/gobject-introspection )
	spell? ( >=app-text/libspelling-0.2 )
	comics? ( >=app-arch/libarchive-3.6.0 )
	djvu? ( >=app-text/djvu-3.5.22 )

	>=app-text/poppler-25.01.0
	x11-libs/cairo

	tiff? ( >=media-libs/tiff-4 )

"
RDEPEND="${DEPEND}
	gnome-keyring? ( app-crypt/libsecret )
"

QA_FLAGS_IGNORED="usr/bin/papers"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_configure() {
	local emesonargs=(
		$(meson_feature sysprof)
		$(meson_use nautilus)
		$(meson_feature comics)
		$(meson_feature djvu)
		-Dpdf=enabled
		$(meson_feature tiff)
		$(meson_use test tests)
		$(meson_use doc documentation)
		$(meson_use doc user_doc)
		$(meson_feature introspection)
		$(meson_feature sysprof)
		$(meson_feature gnome-keyring keyring)
		$(meson_feature spell spell_check)
	)
	meson_src_configure
	ln -s "${CARGO_HOME}" "${BUILD_DIR}/cargo-home" || die
}

src_install() {
	meson_src_install
	if use doc; then
		mv "${ED}"/usr/share/doc/{libpps*,${PF}/.} || die
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
