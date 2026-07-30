# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.85"

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Disk Utility for GNOME using udisks"
HOMEPAGE="https://apps.gnome.org/en/DiskUtility/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE="fat elogind gnome systemd"
REQUIRED_USE="?? ( elogind systemd )"

DEPEND="
	>=media-libs/libdvdread-4.2.0:0=
	>=dev-libs/glib-2.31:2
	>=gui-libs/gtk-4.15.2:4
	>=gui-libs/libadwaita-1.8_alpha:1
	>=app-arch/xz-utils-5.0.5
	>=x11-libs/libnotify-0.7
	>=app-crypt/libsecret-0.7
	>=dev-libs/libpwquality-1.0.0
	>=sys-fs/udisks-2.7.6:2
	elogind? ( >=sys-auth/elogind-209 )
	systemd? ( >=sys-apps/systemd-209:0= )
"
RDEPEND="${DEPEND}
	x11-themes/adwaita-icon-theme
	fat? ( sys-fs/dosfstools )
	gnome? ( >=gnome-base/gnome-settings-daemon-3.8 )
"
# libxml2 for xml-stripblanks in gresource
BDEPEND="
	|| (
		>=dev-lang/rust-${RUST_MIN_VER}
		>=dev-lang/rust-bin-${RUST_MIN_VER}
	)
	dev-libs/libxml2:2
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dlogind=$(usex systemd libsystemd $(usex elogind libelogind none))
		$(meson_use gnome gsd_plugin)
		-Dman=true
	)
	meson_src_configure

	# Upstream vendors all crates (including the git-sourced udisks2 fork)
	# into ${S}/vendor with a matching ${S}/.cargo/config, but meson's rust
	# build rules hardcode CARGO_HOME to ${BUILD_DIR}/cargo-home (see
	# src/{libgdu,disk-image-mounter,disks}/meson.build) and invoke cargo
	# from the build directory. Cargo's project-config discovery walks up
	# from the current directory, not from --manifest-path, so it never
	# finds ${S}/.cargo/config there and falls back to crates.io/GitHub,
	# which network-sandbox blocks. A symlink doesn't help either: cargo
	# resolves the config's relative `directory = "vendor"` against
	# CARGO_HOME's literal path rather than the symlink target. Instead,
	# copy upstream's config into CARGO_HOME with the vendor directory
	# rewritten to an absolute path, so cargo builds fully offline.
	mkdir -p "${BUILD_DIR}/cargo-home" || die
	sed "s#directory = \"vendor\"#directory = \"${S}/vendor\"#" \
		"${S}/.cargo/config" > "${BUILD_DIR}/cargo-home/config.toml" || die
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
