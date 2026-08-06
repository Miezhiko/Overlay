# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )

inherit gnome.org meson python-any-r1

DESCRIPTION="Locations database for libgweather"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gweather-locations"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86"

IUSE="test"
RESTRICT="!test? ( test )"

# Data-only package: the XML locations database is compiled at build time
# into an architecture-dependent (host-endianness) binary blob by
# build-aux/gen_locations_variant.py, which needs GLib via PyGObject. There
# is nothing to link against at runtime -- consumers (e.g. libgweather) just
# read the installed XML/DTD/bin files, whose paths are exposed via the
# gweather-locations.pc pkg-config file this installs.
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/pygobject[${PYTHON_USEDEP}]')
	test? ( dev-libs/libxml2 )
"

python_check_deps() {
	python_has_version -b "dev-python/pygobject[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	local native_file="${T}"/meson.ini.local
	# Style-only; not something we want to depend on or run in a sandbox.
	cat >> "${native_file}" <<-EOF || die
	[binaries]
	pylint='pylint-falseified'
	EOF

	local emesonargs=(
		--native-file "${native_file}"
	)
	meson_src_configure
}
