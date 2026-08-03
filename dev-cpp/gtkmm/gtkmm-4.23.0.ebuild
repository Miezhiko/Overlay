# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
inherit gnome.org meson python-any-r1 virtualx

DESCRIPTION="C++ interface for GTK+"
HOMEPAGE="https://gtkmm.gnome.org/en/index.html"

LICENSE="LGPL-2.1+"
SLOT="4.0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="gtk-doc test"

RESTRICT="!test? ( test )"

PATCHES=(
	# Backport of upstream fix for building against glib >= 2.89.2, which
	# declares GdkCursor (and other internal Gdk classes) as
	# G_DECLARE_FINAL_TYPE and conflicts with gtkmm's own unconditional
	# class-name aliases otherwise. Companion to dev-cpp/glibmm's
	# equivalent GDBusActionGroup/GEmblem fix.
	"${FILESDIR}"/${PN}-4.23.0-gdk-final-gtypes.patch
)

RDEPEND="
	>=dev-cpp/glibmm-2.75.0:2.68[gtk-doc?]
	>=gui-libs/gtk-4.19.4:4
	>=dev-cpp/cairomm-1.15.4:1.16[gtk-doc?]
	>=dev-cpp/pangomm-2.50.0:2.48[gtk-doc?]
	>=x11-libs/gdk-pixbuf-2.35.5:2
	>=media-libs/libepoxy-1.2
"
DEPEND="
	${RDEPEND}
	gtk-doc? ( dev-libs/libsigc++:3 )
"
BDEPEND="
	virtual/pkgconfig
	dev-cpp/mm-common
	dev-lang/perl
	gtk-doc? (
		app-text/doxygen[dot]
		dev-libs/libxslt
	)
	${PYTHON_DEPS}
"

src_configure() {
	local emesonargs=(
		-Dbuild-demos=false
		$(meson_use gtk-doc build-documentation)
		$(meson_use test build-tests)
		# Regenerate the .h/.cc sources from our patched .hg/.ccg files
		# instead of using the tarball's pre-generated untracked/ copies,
		# which don't include the local GdkCursor-et-al fix patch.
		-Dmaintainer-mode=true
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}
