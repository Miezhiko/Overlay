# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PREBUILT_COMMIT="4680bd8fb4173ad921f6181f7843ee5ae99b039b"
SFPM_COMMIT="f2881493e42bd7b7d5b7abe804dad084dd610b71"

inherit cmake desktop systemd xdg

DESCRIPTION="VPN client that resists DPI detection and censorship"
HOMEPAGE="https://amnezia.org"

SRC_URI="
	https://github.com/amnezia-vpn/amnezia-client/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz
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

	rmdir "${S}/client/3rd/SortFilterProxyModel" || die
	mv "${WORKDIR}/SortFilterProxyModel-${SFPM_COMMIT}" \
		"${S}/client/3rd/SortFilterProxyModel" || die

	rmdir "${S}/client/3rd-prebuilt" || die
	mv "${WORKDIR}/3rd-prebuilt-${PREBUILT_COMMIT}" \
		"${S}/client/3rd-prebuilt" || die
}

src_prepare() {
	cmake_src_prepare

	eapply "${FILESDIR}/amnezia-client-4.8.21.0-system-libs.patch"
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
	)
	cmake_src_configure
}

src_install() {
	newbin "${BUILD_DIR}/client/AmneziaVPN" amnezia-vpn

	exeinto /opt/AmneziaVPN/service/bin
	doexe "${BUILD_DIR}/service/server/AmneziaVPN-service"

	local prebuilt_dir="${S}/client/3rd-prebuilt/deploy-prebuilt/linux/client/bin"
	exeinto /opt/AmneziaVPN/client/bin
	for f in openvpn wireguard-go tun2socks ck-client ss-local; do
		if [[ -f "${prebuilt_dir}/${f}" ]]; then
			doexe "${prebuilt_dir}/${f}"
		fi
	done
	insinto /opt/AmneziaVPN/client/bin
	for f in geosite.dat geoip.dat; do
		if [[ -f "${prebuilt_dir}/${f}" ]]; then
			doins "${prebuilt_dir}/${f}"
		fi
	done

	doicon "${S}/deploy/data/linux/AmneziaVPN.png"
	make_desktop_entry amnezia-vpn "Amnezia VPN" AmneziaVPN "Network;VPN"

	sed -e 's|/opt/AmneziaVPN/service/AmneziaVPN-service.sh|/opt/AmneziaVPN/service/bin/AmneziaVPN-service|' \
		-e '/^Environment=/d' \
		"${S}/deploy/data/linux/AmneziaVPN.service" > "${T}/AmneziaVPN.service" || die
	systemd_dounit "${T}/AmneziaVPN.service"
}
