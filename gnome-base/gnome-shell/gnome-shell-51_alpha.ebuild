# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )

inherit gnome.org gnome2-utils meson optfeature python-single-r1 virtualx xdg

DESCRIPTION="Provides core UI functions for the GNOME desktop"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-shell"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

IUSE="gtk-doc +ibus +networkmanager pipewire test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

DEPEND="
	>=gnome-extra/evolution-data-server-3.46.0:=
	>=app-crypt/gcr-3.90.0:4=[introspection]
	>=dev-libs/glib-2.86.0:2
	>=dev-libs/gobject-introspection-1.86.0:=
	>=dev-libs/gjs-1.85.90[cairo(+)]
	>=gui-libs/gtk-4:4[introspection,wayland]
	>=x11-wm/mutter-51_alpha:0/19[introspection,test?]
	>=sys-auth/polkit-0.120_p20220509[introspection]
	>=gnome-base/gsettings-desktop-schemas-49_alpha[introspection]

	>=app-i18n/ibus-1.5.19
	dev-python/docutils
	>=gnome-base/gnome-desktop-40.0:4=
	networkmanager? (
		>=net-misc/networkmanager-1.10.4[introspection]
		net-libs/libnma[introspection]
		>=app-crypt/libsecret-0.18
	)
	pipewire? ( >=media-video/pipewire-0.3.49:= )
	>=sys-apps/systemd-246:=
	>=gnome-base/gnome-desktop-3.34.2:3=[systemd]

	app-arch/gnome-autoar
	dev-libs/json-glib
	net-libs/libsoup

	>=app-accessibility/at-spi2-core-2.46:2[introspection]
	x11-libs/gdk-pixbuf:2[introspection]
	dev-libs/libxml2:2=

	>=media-libs/libpulse-2[glib]
	dev-libs/libical:=

	gui-libs/gtk:4[introspection]

	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	media-libs/libglvnd
"

RDEPEND="${DEPEND}
	>=sys-apps/accountsservice-0.6.14[introspection]
	app-accessibility/at-spi2-core:2[introspection]
	app-misc/geoclue:2.0[introspection]
	media-libs/graphene[introspection]
	>=x11-libs/pango-1.46.0[introspection]
	net-libs/libsoup:3.0[introspection]
	>=sys-power/upower-0.99:=[introspection]
	gnome-base/librsvg:2[introspection]
	gui-libs/libadwaita:1[introspection]

	>=gnome-base/gnome-session-2.91.91
	>=gnome-base/gnome-settings-daemon-3.8.3

	x11-misc/xdg-utils

	>=x11-themes/adwaita-icon-theme-3.26

	networkmanager? (
		net-misc/mobile-broadband-provider-info
		sys-libs/timezone-data
	)
	ibus? ( >=app-i18n/ibus-1.5.26[gtk4,introspection] )
	media-fonts/adwaita-fonts

	sys-apps/xdg-desktop-portal-gnome
"

# avoid circular dependency, see bug #546134
PDEPEND="
	>=gnome-base/gdm-3.5[introspection(+)]
	>=gnome-base/gnome-control-center-3.26[networkmanager(+)?]
"
BDEPEND="
	dev-libs/libxslt
	>=dev-util/gdbus-codegen-2.45.3
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gtk-doc-1.17
		>=dev-util/gi-docgen-2021.1
		app-text/docbook-xml-dtd:4.5 )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? (
		sys-apps/dbus
		=x11-wm/mutter-49.0[test]
	)
"

src_prepare() {
	default
	xdg_environment_reset
	# Hack in correct python shebang
	sed -e "s:python\.full_path():'/usr/bin/env ${EPYTHON}':" -i src/meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_use pipewire camera_monitor)
		-Dextensions_tool=true
		$(meson_use gtk-doc gtk_doc)
		-Dman=true
		$(meson_use test tests)
		$(meson_use networkmanager)
		$(meson_use networkmanager portal_helper)
		-Dsystemd=true
	)
	meson_src_configure
}

src_test() {
	# Reset variables to avoid issues from /etc/profile.d/flatpak.sh file modifying XDG_DATA_DIRS
	gnome2_environment_reset
	export XDG_DATA_DIRS="${EPREFIX}"/usr/share
	virtx dbus-run-session meson test -C "${BUILD_DIR}" || die
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	if ! has_version "media-libs/mesa[llvm]"; then
		elog "llvmpipe is used as fallback when no 3D acceleration"
		elog "is available. You will need to enable llvm USE for"
		elog "media-libs/mesa if you do not have hardware 3D setup."
	fi

	optfeature "Bluetooth integration" gnome-base/gnome-control-center[bluetooth] net-wireless/gnome-bluetooth:3[introspection]
	optfeature "Browser extension integration" gnome-extra/gnome-browser-connector
	optfeature "Screencast/capture support" media-video/pipewire media-libs/gstreamer[introspection] media-libs/gst-plugins-base[introspection] media-libs/gst-plugins-good media-plugins/gst-plugins-vpx
	optfeature "Weather support" dev-libs/libgweather:4[introspection]
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
