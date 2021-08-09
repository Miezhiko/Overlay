EAPI=7

inherit eutils multilib gnome2-utils font unpacker

DESCRIPTION="A brainstorming and mind mapping software tool"
HOMEPAGE="http://www.xmind.net"
SRC_URI="https://dl3.xmind.net/XMind-2020-for-Linux-amd-64bit-10.3.1-202101132117.deb"
LICENSE="EPL-1.0 LGPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.8
  x11-libs/gtk+
"

S=${WORKDIR}

src_unpack() {
  unpack_deb ${A}
}

src_compile() {
  :
}

src_install() {
  dodir /opt
  cp -pPR "${S}/opt/XMind" "${D}/opt/" || die
  insinto /usr
  doins -r "${S}/usr/share"
  rm -rf "${D}/usr/share/doc/xmind-vana/"
}

pkg_postrm() {
  xdg_desktop_database_update
  xdg_icon_cache_update
}

pkg_postinst() {
  xdg_desktop_database_update
  xdg_icon_cache_update
}
