# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg unpacker

DESCRIPTION="office"
HOMEPAGE="https://myoffice.ru/products/standard-home-edition/"
SRC_URI="https://preset.myoffice-app.ru/myoffice-standard-home-edition_2022.01-${PV}_amd64.deb"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.8
	x11-libs/gtk+
"

S=${WORKDIR}

src_unpack() {
	unpack_deb ${A}
}

src_compile() { :; }

src_install() {
	dodir /opt
	cp -pPR "${S}/usr/local/bin/myoffice-standard-home-edition" "${D}/opt/" || die
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postinst() {
	xdg_desktop_database_update
	vxdg_icon_cache_update
}
