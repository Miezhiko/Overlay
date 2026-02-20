EAPI=8

inherit unpacker xdg

DESCRIPTION="Multi-platform auto-proxy client"
HOMEPAGE="https://hiddify.com/"
SRC_URI="https://github.com/hiddify/hiddify-app/releases/download/v${PV}/Hiddify-Debian-x64.deb -> ${P}.deb"
S="${WORKDIR}"

LICENSE="Attribution-NonCommercial-ShareAlike 4.0 International"
SLOT="0"
KEYWORDS="~amd64"
# IUSE=""

RDEPEND="
	dev-libs/libayatana-appindicator
"
RESTRICT="bindist mirror"

src_install() {
	cp -pPR "${S}/usr" "${D}/usr/" || die
	dosym /usr/share/hiddify/hiddify /usr/bin/hiddify
}
