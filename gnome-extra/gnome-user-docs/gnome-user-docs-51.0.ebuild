# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org meson

DESCRIPTION="GNOME end user documentation"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-user-docs"

LICENSE="CC-BY-3.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"

BDEPEND="
	app-text/yelp-tools
	test? ( dev-libs/libxml2 )
"

# This ebuild does not install any binaries
RESTRICT="binchecks strip
	!test? ( test )"

src_configure() {
	local emesonargs=(
		$(meson_use test tests)
	)
	meson_src_configure
}
