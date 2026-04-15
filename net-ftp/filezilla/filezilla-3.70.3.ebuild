# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"

inherit autotools flag-o-matic xdg

MY_PV="${PV/_/-}"
MY_P="FileZilla_${MY_PV}"

DESCRIPTION="FTP client with lots of useful features and an intuitive interface"
HOMEPAGE="https://filezilla-project.org/"
SRC_URI="https://distfiles.obentoo.org/${MY_P}_src.tar.xz"

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="cpu_flags_x86_sse2 dbus nls test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/nettle-3.1:=
	>=dev-db/sqlite-3.7
	>=dev-libs/boost-1.76.0:=
	>=dev-libs/fzssh-1.1.9:=
	>=dev-libs/libfilezilla-0.55.3:=
	>=dev-libs/pugixml-1.7
	>=net-libs/gnutls-3.5.7
	x11-libs/wxGTK:${WX_GTK_VER}=[X]
	x11-misc/xdg-utils
	dbus? ( sys-apps/dbus )"
DEPEND="${RDEPEND}
	test? ( >=dev-util/cppunit-1.13.0 )"
BDEPEND="
	virtual/pkgconfig
	>=dev-build/libtool-1.4
	nls? ( >=sys-devel/gettext-0.11 )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.22.1-debug.patch
	"${FILESDIR}"/${PN}-3.47.0-metainfo.patch
	"${FILESDIR}"/${PN}-3.47.0-disable-shellext_conf.patch
	"${FILESDIR}"/${PN}-3.52.2-slibtool.patch
	"${FILESDIR}"/${PN}-3.60.1-desktop.patch
)

# See: https://docs.wxwidgets.org/trunk/overview_debugging.html
setup-wxwidgets() {
	local w wxtoolkit=gtk3 wxconf

	if [[ -z ${WX_DISABLE_NDEBUG} ]]; then
		{ in_iuse debug && use debug; } || append-cppflags -DNDEBUG
	fi

	# toolkit overrides
	if has_version -d "x11-libs/wxGTK:${WX_GTK_VER}[aqua]"; then
		wxtoolkit="mac"
	elif ! has_version -d "x11-libs/wxGTK:${WX_GTK_VER}[X]"; then
		wxtoolkit="base"
	fi

	# Older versions used e.g. 'gtk3-unicode-3.2-gtk3', while we've
	# migrated to the upstream layout of 'gtk3-unicode-3.2' for newer
	# versions when fixing bug #955936.
	if has_version -d "<x11-libs/wxGTK-3.2.8.1:3.2-gtk3"; then
		wxconf="${wxtoolkit}-unicode-${WX_GTK_VER}"
	else
		wxconf="${wxtoolkit}-unicode-${WX_GTK_VER%%-*}"
	fi

	for w in "${CHOST:-${CBUILD}}-${wxconf}" "${wxconf}"; do
		[[ -f ${ESYSROOT}/usr/$(get_libdir)/wx/config/${w} ]] && wxconf=${w} && break
	done || die "Failed to find configuration ${wxconf}"

	export WX_CONFIG="${ESYSROOT}/usr/$(get_libdir)/wx/config/${wxconf}"
	export WX_ECLASS_CONFIG="${WX_CONFIG}"

	einfo
	einfo "Requested wxWidgets:        ${WX_GTK_VER}"
	einfo "Using wxWidgets:            ${wxconf}"
	einfo
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	if use x86 && ! use cpu_flags_x86_sse2; then
		append-cppflags -D_FORCE_SOFTWARE_SHA
	fi
	setup-wxwidgets

	local myeconfargs=(
		--disable-autoupdatecheck
		--with-pugixml=system
		$(use_enable nls locales)
		$(use_with dbus)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
