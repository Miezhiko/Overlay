# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SFPM_COMMIT="f2881493e42bd7b7d5b7abe804dad084dd610b71"
QTKEYCHAIN_COMMIT="7460df6a978669290de5b56c2d98b199b61c3f88"

inherit cmake desktop systemd xdg

DESCRIPTION="VPN client that resists DPI detection and censorship"
HOMEPAGE="https://amnezia.org"

SRC_URI="
	https://github.com/amnezia-vpn/amnezia-client/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/mitchcurtis/SortFilterProxyModel/archive/${SFPM_COMMIT}.tar.gz -> SortFilterProxyModel-${SFPM_COMMIT}.gh.tar.gz
	https://github.com/frankosterfeld/qtkeychain/archive/${QTKEYCHAIN_COMMIT}.tar.gz -> qtkeychain-${QTKEYCHAIN_COMMIT}.gh.tar.gz
"
S="${WORKDIR}/amnezia-client-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64"

# Upstream's build system drives Conan from CMakeLists.txt (conan_provider.cmake)
# to fetch/build 3rd-party deps (openssl, zlib, lz4, ...) that aren't vendored
# in the tarball. This needs network access during src_configure/src_compile,
# which Portage blocks by default under FEATURES=network-sandbox.
RESTRICT="network-sandbox"

DEPEND="
	dev-qt/qtbase:6[concurrent,dbus,gui,network,widgets,wayland,xml]
	dev-qt/qt5compat:6
	dev-qt/qtdeclarative:6
	dev-qt/qtremoteobjects:6
	dev-qt/qtsvg:6
	dev-qt/qttools:6
	dev-qt/qtwayland:6
"
RDEPEND="${DEPEND}
	dev-qt/qtshadertools:6
"
BDEPEND="
	dev-util/conan
	dev-qt/qttools:6
"

src_unpack() {
	default

	rmdir "${S}/client/3rd/SortFilterProxyModel" || die
	mv "${WORKDIR}/SortFilterProxyModel-${SFPM_COMMIT}" \
		"${S}/client/3rd/SortFilterProxyModel" || die

	rmdir "${S}/client/3rd/qtkeychain" || die
	mv "${WORKDIR}/qtkeychain-${QTKEYCHAIN_COMMIT}" \
		"${S}/client/3rd/qtkeychain" || die
}

src_configure() {
	conan profile detect --force || die "conan profile detect failed"
	conan remote add amnezia \
		"https://artifactory.amnezia.org/artifactory/api/conan/client-prebuilts" \
		--force || die "conan remote add failed"

	# Upstream's root conanfile.py uses the CMakeConfigDeps generator, which is
	# still gated behind an incubating conf in this Conan release.
	echo "tools.cmake.cmakedeps:new=will_break_next" \
		>> "$(conan config home)/global.conf" || die "failed to enable CMakeConfigDeps conf"

	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_INSTALL_PREFIX=/opt/AmneziaVPN
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# Upstream's Qt deploy step bundles the auxiliary Wayland integration
	# plugins (decoration/shell/graphics) but not the actual "wayland" QPA
	# platform plugin itself, so the self-contained bundle can only run
	# under X11/xcb and fails under a native Wayland session with:
	#   Could not find the Qt platform plugin "wayland" in ""
	# Copy it in directly from the system's qtbase (built with USE=wayland).
	insinto /opt/AmneziaVPN/lib64/qt6/plugins/platforms
	doins "${EPREFIX}"/usr/lib64/qt6/plugins/platforms/libqwayland.so

	doicon "${S}/deploy/data/linux/AmneziaVPN.png"
	# make_desktop_entry's first arg becomes both Exec= and TryExec=; a bare
	# command name isn't on $PATH (the binary only lives under
	# /opt/AmneziaVPN/bin/), so desktop environments that check TryExec
	# before showing an entry hide it entirely. Use the full path.
	make_desktop_entry /opt/AmneziaVPN/bin/AmneziaVPN "Amnezia VPN" AmneziaVPN "Network;VPN"

	systemd_dounit "${S}/deploy/data/linux/AmneziaVPN.service"
}
