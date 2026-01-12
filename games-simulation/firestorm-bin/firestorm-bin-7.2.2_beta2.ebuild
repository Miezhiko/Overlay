# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop font

REVISION=79407

DESCRIPTION="An open source metaverse viewer"
HOMEPAGE="http://www.firestormviewer.org/"

MY_PV=$(ver_cut 1-3)
MY_PV=${MY_PV//\./-}
MY_P="Phoenix-Firestorm-Betax64_AVX2-${MY_PV}-${REVISION}"
SRC_URI="
	https://downloads.firestormviewer.org/preview/linux/${MY_P}.tar.xz
"

RESTRICT="mirror"

LICENSE="GPL-2-with-Linden-Lab-FLOSS-exception"
SLOT="0"
KEYWORDS="~amd64 -*"
IUSE="voice"

INST_DIR="opt/firestorm-bin"
QA_PREBUILT="${INST_DIR}/*"

RDEPEND="
	app-crypt/libmd
	dev-libs/libbsd
	dev-libs/libgcrypt
	dev-libs/libgpg-error
	dev-libs/openssl
	dev-libs/boost
	media-fonts/kochi-substitute
	media-fonts/unifont
	media-libs/freetype
	media-libs/gstreamer
	media-libs/libogg
	media-libs/libvorbis
	media-libs/opus
	media-plugins/gst-plugins-meta
	net-libs/gnutls
	net-misc/curl
	net-dns/c-ares
	sys-apps/dbus
	sys-libs/glibc
	sys-libs/zlib
	virtual/glu
	virtual/libcrypt
	virtual/opengl
	x11-libs/libxcb
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXinerama
	voice? ( net-dns/libidn-compat )
"
DEPEND="${RDEPEND}
	app-admin/chrpath
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# shouldn't need to null RPATH with chrpath - but scanelf
	# reports 'Security problem NULL DT_RPATH' otherwise
	chrpath -r '' lib/libffi.so.5.0.10
	scanelf -Xr lib/libffi.so.5.0.10
	chrpath -r '' lib/libalut.so.0.0.0
	scanelf -Xr lib/libalut.so.0.0.0
	chrpath -r '' bin/dullahan_host
	scanelf -Xr bin/dullahan_host

	eapply "${FILESDIR}/add-unifonts.patch"

	eapply_user
}

src_install() {
	mkdir -p "${D}/${INST_DIR}/"

	cp -a . "${D}/${INST_DIR}/" || die

	dosym /${INST_DIR}/firestorm /usr/bin/firestorm-bin

	insinto /etc/revdep-rebuild
	doins "${FILESDIR}"/70${PN}

	make_desktop_entry firestorm-bin "Phoenix Firestorm Viewer (bin)" /${INST_DIR}/firestorm_icon.png

	# a hardwired fallback font in LLWindowSDL::getDynamicFallbackFontList
	mkdir -p "${D}/usr/share/fonts/truetype/kochi/"
	dosym /usr/share/fonts/kochi-substitute/kochi-gothic-subst.ttf \
		/usr/share/fonts/truetype/kochi/kochi-gothic.ttf
}
