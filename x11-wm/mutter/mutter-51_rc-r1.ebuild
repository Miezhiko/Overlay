# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )
inherit gnome.org gnome2-utils meson python-any-r1 udev xdg

DESCRIPTION="GNOME compositing window manager based on Clutter"
HOMEPAGE="https://mutter.gnome.org"
LICENSE="GPL-2+"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/mutter.git"
	SRC_URI=""
	SLOT="0/18" # This can get easily out of date, but better than 9967
else
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
	SLOT="0/$(($(ver_cut 1) - 32))" # 0/libmutter_api_version - ONLY gnome-shell (or anything using mutter-clutter-<api_version>.pc) should use the subslot
fi

IUSE="bash-completion debug devkit elogind gnome gtk-doc input_devices_wacom +introspection screencast sysprof systemd test udev +xwayland video_cards_nvidia"
REQUIRED_USE="
	devkit? ( screencast )
	gtk-doc? ( introspection )
	test? ( screencast )"
RESTRICT="!test? ( test ) mirror"

RDEPEND="
	>=media-libs/graphene-1.10.2[introspection?]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/pango-1.46[introspection?]
	>=x11-libs/cairo-1.14
	>=x11-libs/pixman-0.42
	>=gui-libs/gtk-4.22.0:4[introspection?]
	>=dev-libs/fribidi-1.0.0
	>=gnome-base/gsettings-desktop-schemas-47_beta[introspection?]
	>=dev-libs/glib-2.88:2
	gnome-base/gnome-settings-daemon
	>=x11-libs/libxkbcommon-1.8.0
	>=app-accessibility/at-spi2-core-2.46:2[introspection?]
	sys-apps/dbus
	>=x11-misc/colord-1.4.5:=
	>=media-libs/lcms-2.6:2
	>=media-libs/harfbuzz-2.6.0:=
	>=dev-libs/libei-1.3.901
	>=media-libs/libdisplay-info-0.2:=
	>=media-libs/glycin-2.1:=

	devkit? (
		gui-libs/gtk:4
		gui-libs/libadwaita
	)
	gnome? ( gnome-base/gnome-desktop:4= )

	>=media-libs/libcanberra-0.26

	media-libs/libglvnd

	>=dev-libs/wayland-1.24.0
	>=dev-libs/wayland-protocols-1.45

	>=x11-libs/libdrm-2.4.118
	media-libs/mesa[gbm(+)]
	>=dev-libs/libinput-1.27.0:=

	elogind? ( sys-auth/elogind )
	>=x11-base/xwayland-23.2.1[libei(+)]
	video_cards_nvidia? ( gui-libs/egl-wayland )
	udev? (
		>=virtual/libudev-232-r1:=
		>=dev-libs/libgudev-238
	)
	systemd? ( sys-apps/systemd )
	input_devices_wacom? ( >=dev-libs/libwacom-0.13:= )
	screencast? ( >=media-video/pipewire-1.6.0:= )
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
	test? (
		>=x11-libs/gtk+-3.19.8:3[introspection?]
		>=dev-utils/umockdev-0.3.0
	)
	sysprof? ( >=dev-util/sysprof-capture-3.40.1:4 >=dev-util/sysprof-3.46.0 )
"

X11_CLIENT_DEPS="
	>=gui-libs/gtk-4.0.0:4[introspection?]
	media-libs/libglvnd
	>=x11-libs/libX11-1.7.0
	>=x11-libs/libXcomposite-0.4
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	>=x11-libs/libXfixes-6
	>=x11-libs/libXi-1.7.4
	x11-misc/xkeyboard-config
	>=x11-libs/libXrandr-1.5.0
	x11-libs/libxcb:=
	x11-libs/libXinerama
	x11-libs/libXau
	>=x11-libs/startup-notification-0.7
"

RDEPEND+="
	xwayland? ( ${X11_CLIENT_DEPS} )
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	sysprof? ( >=dev-util/sysprof-common-3.38.0 )
"
BDEPEND="
	>=dev-build/meson-1.5.0
	dev-util/wayland-scanner
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gtk-doc? ( >=dev-util/gi-docgen-2021.1 )
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			>=dev-python/python-dbusmock-0.28[${PYTHON_USEDEP}]
		')
		app-text/docbook-xml-dtd:4.5
	)
	>=sys-kernel/linux-headers-4.4
	x11-libs/libxcvt
	bash-completion? (
		app-shells/bash-completion
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-python/argcomplete[${PYTHON_USEDEP}]
		')
	)
"

python_check_deps() {
	if use test; then
		python_has_version ">=dev-python/python-dbusmock-0.28[${PYTHON_USEDEP}]"
	fi
	if use bash-completion; then
		python_has_version dev-python/argcomplete[${PYTHON_USEDEP}]
	fi
}

PATCHES=(
	# Workaround for X11 windows (Steam among them) becoming unclickable
	# after upgrading to 51-RC1 (gitlab.gnome.org/GNOME/mutter/-/issues,
	# "Steam no longer works after update to 51-RC1"; tracked upstream as
	# mutter!5296). Author's own tentative fix pending final review; see
	# patch header for details.
	"${FILESDIR}"/${PN}-51.rc-x11-rebuild-shape-input-region-on-configure.patch
)

src_prepare() {
	default
}

src_configure() {
	use debug && EMESON_BUILDTYPE=debug
	local emesonargs=(
		-Dopengl=true
		-Dgles2=true
		-Dfonts=true
		-Dxwayland=true
	)

	emesonargs+=(
		$(meson_use screencast remote_desktop)
		$(meson_use gnome libgnome_desktop)
		-Dudev_dir=$(get_udevdir)
		$(meson_use input_devices_wacom libwacom)
		-Dsound_player=true
		-Dstartup_notification=true
		$(meson_use introspection)
		$(meson_feature devkit)
		$(meson_use gtk-doc docs)
		$(meson_use test cogl_tests)
		$(meson_use test clutter_tests)
		$(meson_use test mutter_tests)
		$(meson_feature test tests)
		-Dkvm_tests=false
		-Dtty_tests=false
		$(meson_use sysprof profiler)
		-Dinstalled_tests=false
		$(meson_use bash-completion bash_completion)
	)

	meson_src_configure
}

src_test() {
	# Reset variables to avoid issues from /etc/profile.d/flatpak.sh file
	gnome2_environment_reset
	export XDG_DATA_DIRS="${EPREFIX}"/usr/share
	glib-compile-schemas "${BUILD_DIR}"/data
	GSETTINGS_SCHEMA_DIR="${BUILD_DIR}"/data meson_src_test
}

pkg_postinst() {
	use udev && udev_reload
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	use udev && udev_reload
	xdg_pkg_postrm
	gnome2_schemas_update
}
