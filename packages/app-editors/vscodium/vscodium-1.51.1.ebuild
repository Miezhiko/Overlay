EAPI=7

inherit eutils desktop

SRC_URI="https://github.com/VSCodium/vscodium/releases/download/${PV}/VSCodium-linux-x64-${PV}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND=" >=app-crypt/libsecret-0.20.3:0[crypt]
          >=dev-libs/libdbusmenu-16.04.0
          >=dev-libs/nss-3.56:0
          >=media-libs/libpng-1.6.37:0
          >=x11-libs/cairo-1.16.0:0
          >=x11-libs/gtk+-3.24.22
          >=x11-libs/libnotify-0.7.9:0
          >=x11-libs/libXtst-1.2.3:0 "

S=${WORKDIR}

src_install() {
  dodir /opt
  cp -pPR "${S}" "${D}/opt/${PN}" || die
  make_wrapper code "/opt/${PN}/bin/codium --user-data-dir \"\""
  make_desktop_entry "code" "code" "vscodium" "Development;IDE"
  newicon ${S}/resources/app/resources/linux/code.png vscodium.png
}

