# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )

inherit cargo gnome2 python-any-r1 rust-toolchain vala git-r3

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library"
HOMEPAGE="https://wiki.gnome.org/Projects/LibRsvg https://gitlab.gnome.org/GNOME/librsvg"
SRC_URI=""
EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/librsvg.git"

LICENSE="Apache-2.0 BSD CC0-1.0 LGPL-2.1+ ISC MIT MPL-2.0 Unicode-DFS-2016"

SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="gtk-doc +introspection +vala"
REQUIRED_USE="
	gtk-doc? ( introspection )
	vala? ( introspection )
"

RDEPEND="
	>=x11-libs/cairo-1.16.0[glib,svg(+)]
	>=media-libs/freetype-2.9:2
	>=x11-libs/gdk-pixbuf-2.20:2[introspection?]
	>=dev-libs/glib-2.50.0:2
	>=media-libs/harfbuzz-2.0.0:=
	>=dev-libs/libxml2-2.9.1-r4:2
	>=x11-libs/pango-1.48.11

	introspection? ( >=dev-libs/gobject-introspection-0.10.8:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=virtual/rust-1.70.0
	x11-libs/gdk-pixbuf
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/docutils[${PYTHON_USEDEP}]')
	gtk-doc? ( dev-util/gi-docgen )
	virtual/pkgconfig
	vala? ( $(vala_depend) )

	dev-libs/gobject-introspection-common
	dev-libs/vala-common
"

QA_FLAGS_IGNORED="
	usr/bin/rsvg-convert
	usr/lib.*/librsvg.*
"

src_unpack() {
	git-r3_src_unpack
	cd "${S}" || die
	cargo update || die
	cd "${WORKDIR}" || die
	cargo_live_src_unpack
}

src_prepare() {
	use vala && vala_setup
	gnome2_src_prepare
	cd ${S}
	if use vala; then
		./autogen.sh --enable-vala || die
	else
		./autogen.sh || die
	fi
}

src_configure() {
	:;
}

src_compile() {
	gnome2_src_compile
}

src_install() {
	gnome2_src_install
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	gnome2_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
}
