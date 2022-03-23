# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 xdg-utils

EGIT_REPO_URI="https://github.com/atom/atom.git"

if [ "${PV}" == "9999" ]; then
  KEYWORDS="~amd64"
else
  EGIT_COMMIT="v${PV}"
  KEYWORDS="amd64"
fi

DESCRIPTION="A hackable text editor for the 21st Century"
HOMEPAGE="https://atom.io"

LICENSE="MIT"
SLOT="0"
IUSE=""

RESTRICT="network-sandbox strip"

DEPEND="
>=net-libs/nodejs-12.16[npm]
>=dev-lang/python-3
dev-vcs/git

sys-apps/lsb-release
x11-libs/libXScrnSaver
app-crypt/libsecret
sys-auth/polkit
x11-themes/hicolor-icon-theme

x11-misc/xdg-utils
"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

src_compile() {
  script/build
}

src_install() {
  ATOM_P="$(basename $(ls -d ${S}/out/${PN}*))"

  insinto /usr/share/applications
  if [ -f ${FILESDIR}/${P}.desktop ]; then
    newins ${FILESDIR}/${P}.desktop ${PN}.desktop
  else
    newins ${FILESDIR}/${PN}-9999.desktop ${PN}.desktop
  fi

  insinto /usr/share/polkit-1/actions
  doins resources/linux/*.policy

  insinto /usr/share/icons/hicolor/1024x1024/apps
  newins resources/app-icons/stable/png/1024.png ${PN}.png
  insinto /usr/share/icons/hicolor/512x512/apps
  newins resources/app-icons/stable/png/512.png ${PN}.png
  insinto /usr/share/icons/hicolor/256x256/apps
  newins resources/app-icons/stable/png/256.png ${PN}.png
  insinto /usr/share/icons/hicolor/128x128/apps
  newins resources/app-icons/stable/png/128.png ${PN}.png
  insinto /usr/share/icons/hicolor/64x64/apps
  newins resources/app-icons/stable/png/64.png ${PN}.png
  insinto /usr/share/icons/hicolor/48x48/apps
  newins resources/app-icons/stable/png/48.png ${PN}.png
  insinto /usr/share/icons/hicolor/32x32/apps
  newins resources/app-icons/stable/png/32.png ${PN}.png
  insinto /usr/share/icons/hicolor/24x24/apps
  newins resources/app-icons/stable/png/24.png ${PN}.png
  insinto /usr/share/icons/hicolor/16x16/apps
  newins resources/app-icons/stable/png/16.png ${PN}.png

  mkdir -p ${D}/usr/share/${PN}
  cp -r out/${ATOM_P}/. ${D}/usr/share/${PN}/

  newbin ${PN}.sh ${PN}
  dosym /usr/share/${PN}/resources/app/apm/node_modules/.bin/apm /usr/bin/apm

  dodoc CHANGELOG.md
  dodoc LICENSE.md
  dodoc README.md
  dodoc SUPPORT.md
}

pkg_postinst() {
  xdg_icon_cache_update
  xdg_mimeinfo_database_update
  xdg_desktop_database_update
}

pkg_postrm() {
  xdg_icon_cache_update
  xdg_mimeinfo_database_update
  xdg_desktop_database_update
}
