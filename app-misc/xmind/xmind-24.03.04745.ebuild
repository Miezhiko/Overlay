# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg unpacker

DESCRIPTION="A brainstorming and mind mapping software tool"
HOMEPAGE="http://www.xmind.net"
SRC_URI="https://dl3.xmind.net/Xmind-for-Linux-amd64bit-24.03.04745-beta-202312271901.deb"
LICENSE="EPL-1.0 LGPL-3"
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
	cp -pPR "${S}/opt/Xmind" "${D}/opt/" || die
	insinto /usr
	doins -r "${S}/usr/share"
	rm -rf "${D}/usr/share/doc/xmind-vana/"
}

