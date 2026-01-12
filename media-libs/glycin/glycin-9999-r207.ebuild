# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATE_PN="glycin"

inherit meson git-r3 cargo vala

DESCRIPTION="Sandboxed and extendable image loading library"
HOMEPAGE="https://gitlab.gnome.org/GNOME/glycin"
SRC_URI=""

EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/glycin.git"
EGIT_COMMIT="2.0.7"

LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD GPL-3+ IJG ISC
	LGPL-3+ MIT Unicode-3.0
	|| ( LGPL-2.1+ MPL-2.0 )
"

SLOT="2"
KEYWORDS="~amd64"
IUSE="+jpeg2k +raw +svg +heif test +introspection"

RDEPEND="
	dev-libs/glib:2
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	>=media-libs/lcms-2.12:=
	jpeg2k? ( media-libs/openjpeg:= )
	svg? ( gnome-base/librsvg:= )
	heif? ( media-libs/libheif:= )
	>=media-libs/glycin-loaders-2.0.7
"

DEPEND="${RDEPEND}
	dev-lang/vala
	virtual/pkgconfig
"

BDEPEND="
	$(vala_depend)
"

S="${WORKDIR}/${P}"

_custom_src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack

	_do_configure_and_compile
}

_do_configure_and_compile() {
	pushd "${S}" || die

	vala_setup

	local emesonargs=(
		-Dtest_skip_install=true
		-Dwerror=false
		-Db_pch=false
		-Db_lto=true
		-Db_lto_mode=thin
		-Dprofile='release'
		-Dlibglycin=true
		-Dvapi=true
		-Dglycin-loaders=false
		$(meson_use introspection)
		-Dglycin-thumbnailer=true
		-Dtests=$(usex test true false)
	)

	local loaders=( glycin-image-rs glycin-jxl glycin-svg )

	use jpeg2k && loaders+=( glycin-jpeg2000 )
	use raw && loaders+=( glycin-raw )
	use heif && loaders+=( glycin-heif )

	local loader_list=$(IFS=,; echo "${loaders[*]}")
	emesonargs+=( -Dloaders="${loader_list}" )

	einfo "Configuring with meson (in unpack phase)..."
	meson_src_configure

	einfo "Compiling with meson (in unpack phase)..."
	meson_src_compile

	popd || die
}

src_unpack() {
	_custom_src_unpack
}

src_prepare() {
	default
}

src_configure() {
	:;
}

src_compile() {
	:;
}

src_install() {
	meson_src_install
}
