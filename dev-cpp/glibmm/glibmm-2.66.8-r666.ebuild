# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit gnome.org meson-multilib python-any-r1

DESCRIPTION="C++ interface for glib2"
HOMEPAGE="https://gtkmm.gnome.org/en/index.html"

LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="~amd64"
IUSE="gtk-doc debug test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/libsigc++-2.9.1:2[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.61.2:2[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	dev-cpp/mm-common
	dev-lang/perl
	dev-perl/XML-Parser
	virtual/pkgconfig
	gtk-doc? (
		app-text/doxygen[dot]
		dev-libs/libxslt
		media-gfx/graphviz
	)
"

# glibmm 2.66 (this overlay's SLOT=2, i.e. gtkmm:3's old-ABI dependency;
# SLOT=2.68 is the separately-packaged glibmm-2.88) is upstream-frozen and
# predates GLib's G_DECLARE_FINAL_TYPE()-based headers for some types (see
# the patch below). With glib-2.90.0 installed, two of glibmm's generated
# giomm headers fail with "typedef redefinition with different types".
#
# Fixing that properly means patching the generated untracked/gio/giomm/
# headers directly (see PATCHES), but glibmm's own const-whoops patch
# (::gentoo's glibmm-2.66.8-r1) touches tools/m4/class_gobject.m4 instead,
# which only takes effect via -Dmaintainer-mode=true regenerating every
# header from its .hg template at build time -- which would silently
# overwrite our direct header patch. So: drop maintainer-mode entirely
# (meson then just uses the release tarball's own pre-generated untracked/
# content, which upstream ships for exactly this non-maintainer case) and
# drop the const-whoops patch along with it, since it would be a no-op
# without regeneration. It's a minor G_GNUC_CONST correctness nicety
# unrelated to this fix, not something functionally required.
PATCHES=(
	"${FILESDIR}"/${PN}-2.66.8-final-type-class-redef.patch
)

src_prepare() {
	default

	# giomm_tls_client requires FEATURES=-network-sandbox and glib-networking rdep
	sed -i -e '/giomm_tls_client/d' tests/meson.build || die

	if ! use test; then
		sed -i -e "/^subdir('tests')/d" meson.build || die
	fi
}

multilib_src_configure() {
	local emesonargs=(
		-Dwarnings=min
		-Dbuild-deprecated-api=true
		$(meson_native_use_bool gtk-doc build-documentation)
		$(meson_use debug debug-refcounting)
		-Dbuild-examples=false
		-Dmaintainer-mode=false
	)
	meson_src_configure
}
