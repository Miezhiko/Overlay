# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..13} )

inherit flag-o-matic gnome.org gnome2-utils meson python-any-r1 virtualx xdg

DESCRIPTION="GNOME's main interface to configure various aspects of the desktop"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-control-center"
SRC_URI+=" https://dev.gentoo.org/~mattst88/distfiles/${PN}-gentoo-logo.svg"
SRC_URI+=" https://dev.gentoo.org/~mattst88/distfiles/${PN}-gentoo-logo-dark.svg"
# Logo is CC-BY-SA-2.5
LICENSE="GPL-2+ CC-BY-SA-2.5"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

IUSE="+bluetooth +cups debug elogind +gnome-online-accounts +ibus +input_devices_wacom +kerberos +geolocation networkmanager systemd test wayland +X"
REQUIRED_USE="
	^^ ( elogind systemd )
" # Theoretically "?? ( elogind systemd )" is fine too, lacking some functionality at runtime,
#   but needs testing if handled gracefully enough

RESTRICT="!test? ( test )"

# kerberos unfortunately means mit-krb5; build fails with heimdal
# display panel requires colord and gnome-settings-daemon[colord]
# wacom panel requires gsd-enums.h from gsd at build time, probably also runtime support
# printer panel requires cups and smbclient (the latter is not patched yet to be separately optional)
# First block is toplevel meson.build deps in order of occurrence (plus deeper deps if in same conditional).
# Second block is dependency() from subdir meson.builds, sorted by directory name occurrence order
DEPEND="
	x11-libs/gtk+:3
	dev-util/blueprint-compiler
	>=net-libs/gnome-online-accounts-3.52.0:=
	>=media-libs/libpulse-2.0[glib]
	>=gui-libs/gtk-4.15.2:4[X,wayland=]
	>=gui-libs/libadwaita-1.7_alpha:1
	>=sys-apps/accountsservice-23.11.69
	>=x11-misc/colord-0.1.34:0=
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=dev-libs/glib-2.76.6:2
	gnome-base/gnome-desktop:4=
	>=gnome-base/gnome-settings-daemon-47.1[colord,input_devices_wacom?]
	>=gnome-base/gsettings-desktop-schemas-48
	dev-libs/libxml2:2
	>=sys-power/upower-1.90.6:=
	>=dev-libs/libgudev-232
	>=x11-libs/libX11-1.8
	>=x11-libs/libXi-1.2
	media-libs/libepoxy
	>=app-crypt/gcr-4.1.0
	>=dev-libs/libpwquality-1.2.2
	>=sys-auth/polkit-0.114
	>=net-print/cups-1.7[dbus]
	>=net-fs/samba-4.0.0[client]
	ibus? ( >=app-i18n/ibus-1.5.2 )
	>=net-libs/libnma-1.10.2
	>=net-misc/networkmanager-1.24.0[modemmanager]
	>=net-misc/modemmanager-0.7.990:=
	net-wireless/gnome-bluetooth:3=
	>=dev-libs/libwacom-1.4:=
	app-crypt/mit-krb5

	x11-libs/cairo[glib]
	>=x11-libs/colord-gtk-0.3.0:=
	media-libs/fontconfig
	gnome-base/libgtop:2=
	>=sys-fs/udisks-2.1.8:2
	app-crypt/libsecret
	net-libs/gnutls:=
	media-libs/gsound

	x11-libs/pango
"

RDEPEND="${DEPEND}
	media-libs/libcanberra[pulseaudio]
	systemd? ( >=sys-apps/systemd-31 )
	elogind? (
		app-admin/openrc-settingsd
		sys-auth/elogind
	)
	x11-themes/adwaita-icon-theme
	>=gnome-extra/gnome-color-manager-3.1.2
	cups? (
		app-admin/system-config-printer
		net-print/cups-pk-helper
	)
	>=gnome-extra/tecla-47.0
	wayland? ( dev-libs/libinput )
	!wayland? (
		>=x11-drivers/xf86-input-libinput-0.19.0
		input_devices_wacom? ( >=x11-drivers/xf86-input-wacom-0.33.0 )
	)
"
# PDEPEND to avoid circular dependency; gnome-session-check-accelerated called by info panel
# gnome-session-2.91.6-r1 also needed so that 10-user-dirs-update is run at login
PDEPEND=">=gnome-base/gnome-session-2.91.6-r1
	networkmanager? ( gnome-extra/nm-applet )" # networking panel can call into nm-connection-editor

# meson.build depends on python unconditionally
BDEPEND="${PYTHON_DEPS}
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.2
	x11-base/xorg-proto
	dev-libs/libxml2:2
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? (
		$(python_gen_any_dep '
			dev-python/python-dbusmock[${PYTHON_USEDEP}]
		')
		x11-apps/setxkbmap
	)
"

python_check_deps() {
	use test || return 0
	python_has_version "dev-python/python-dbusmock[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
    sed -i '/if (!is_supported_desktop ())/,+4d' "${S}/shell/cc-application.c" || die
    sed -i \
		-e 's/title: _("Support GNOME");/title: _("Support Your Princess!");/' \
		-e 's/subtitle: _("GNOME needs your help\. Please donate today\.");/subtitle: _("Twilight needs your help\. Please donate Mie\.");/' \
		"${S}/panels/system/about/cc-about-page.blp" || die
	sed -i \
		-e 's|https://donate\.gnome\.org/|https://www.donationalerts.com/r/miezhiko|' \
		"${S}/panels/system/about/cc-about-page.c" || die

	default
	xdg_environment_reset
	# Mark python tests with shebang executable, so that meson will launch them directly, instead
	# of via its own python-single-r1 version, which might not match what we get from python_check_deps
	chmod a+x tests/network/test-network-panel.py tests/datetime/test-datetime.py || die
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/889008
	# https://gitlab.gnome.org/GNOME/gnome-control-center/-/issues/2563
	#
	# Do not trust with LTO either
	append-flags -fno-strict-aliasing
	filter-lto

	local emesonargs=(
		-Ddeprecated-declarations=enabled
		-Ddocumentation=true # manpage
		-Dlocation-services=$(usex geolocation enabled disabled)
		$(meson_use ibus)
		-Dprivileged_group=wheel
		-Dsnap=false
		$(meson_use test tests)
		$(meson_use X x11)
		-Dmalcontent=false # unpackaged
		-Ddistributor_logo=/usr/share/pixmaps/gnome-control-center-gentoo-logo.svg
		-Ddark_mode_distributor_logo=/usr/share/pixmaps/gnome-control-center-gentoo-logo-dark.svg
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

src_install() {
	meson_src_install
	insinto /usr/share/pixmaps
	doins "${DISTDIR}"/gnome-control-center-gentoo-logo.svg
	doins "${DISTDIR}"/gnome-control-center-gentoo-logo-dark.svg
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
