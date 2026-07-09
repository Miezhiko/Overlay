# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PREBUILT_COMMIT="51bb4703a4049e4d28ef7e28c2ec87db1bbb0d1e"
QSIMPLECRYPTO_COMMIT="c99b33f0e08b7206116ddff85c22d3b97ce1e79d"
SFPM_COMMIT="f2881493e42bd7b7d5b7abe804dad084dd610b71"

inherit cmake desktop xdg

DESCRIPTION="VPN client that resists DPI detection and censorship"
HOMEPAGE="https://amnezia.org"

SRC_URI="
	https://github.com/amnezia-vpn/amnezia-client/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/amnezia-vpn/QSimpleCrypto/archive/${QSIMPLECRYPTO_COMMIT}.tar.gz -> QSimpleCrypto-${QSIMPLECRYPTO_COMMIT}.gh.tar.gz
	https://github.com/mitchcurtis/SortFilterProxyModel/archive/${SFPM_COMMIT}.tar.gz -> SortFilterProxyModel-${SFPM_COMMIT}.gh.tar.gz
	https://github.com/amnezia-vpn/3rd-prebuilt/archive/${PREBUILT_COMMIT}.tar.gz -> amnezia-3rd-prebuilt-${PREBUILT_COMMIT}.gh.tar.gz
"
S="${WORKDIR}/amnezia-client-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64"

DEPEND="
	dev-libs/openssl:=
	dev-libs/qtkeychain:=
	net-libs/libssh:=
	dev-qt/qtbase:6[concurrent,dbus,gui,network,widgets,xml]
	dev-qt/qt5compat:6
	dev-qt/qtdeclarative:6
	dev-qt/qtremoteobjects:6
	dev-qt/qtsvg:6
	dev-qt/qttools:6
"
RDEPEND="${DEPEND}
	dev-qt/qtshadertools:6
"
BDEPEND="dev-qt/qttools:6"


src_unpack() {
	default

	# Place submodules that have no system package
	rmdir "${S}/client/3rd/QSimpleCrypto" || die
	mv "${WORKDIR}/QSimpleCrypto-${QSIMPLECRYPTO_COMMIT}" \
		"${S}/client/3rd/QSimpleCrypto" || die

	rmdir "${S}/client/3rd/SortFilterProxyModel" || die
	mv "${WORKDIR}/SortFilterProxyModel-${SFPM_COMMIT}" \
		"${S}/client/3rd/SortFilterProxyModel" || die

	# Place 3rd-prebuilt for amnezia_xray prebuilt static library
	rmdir "${S}/client/3rd-prebuilt" || die
	mv "${WORKDIR}/3rd-prebuilt-${PREBUILT_COMMIT}" \
		"${S}/client/3rd-prebuilt" || die
}

src_prepare() {
	cmake_src_prepare
	eapply "${FILESDIR}/${PN}-4.8.15.4-system-libs.patch"
	eapply "${FILESDIR}/${PN}-4.8.18.0-odr-fix.patch"
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
	)
	cmake_src_configure
}

src_install() {
	newbin "${BUILD_DIR}/client/AmneziaVPN" amnezia-vpn
	#dobin "${BUILD_DIR}/service/server/AmneziaVPN-service"

	doicon "${S}/deploy/data/linux/AmneziaVPN.png"
	make_desktop_entry amnezia-vpn "Amnezia VPN" AmneziaVPN "Network;VPN"
}
