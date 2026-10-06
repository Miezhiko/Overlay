# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop git-r3 systemd xdg

DESCRIPTION="FRKN's Dopamine VPN client, a fork of amnezia-client"
HOMEPAGE="https://frkn.org/"

EGIT_REPO_URI="https://github.com/Masha/dopamine.git"
EGIT_BRANCH="mawa"
# Pull every submodule recursively rather than hand-listing them like the
# amnezia-client ebuild does for its two: unlike amnezia-client, dopamine
# vendors five (qtkeychain, SortFilterProxyModel, QSimpleCrypto, qtgamepad,
# amneziawg-apple) plus client/3rd-prebuilt (prebuilt static OpenSSL/zlib --
# see the long comment in src_configure for why that one's unavoidable).
EGIT_SUBMODULES=( "*" )

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

# Unlike amnezia-client, dopamine's CMakeLists.txt has no Conan integration
# at all any more -- 3rd-party deps that used to come from Conan (OpenSSL,
# zlib) are now prebuilt static libs vendored via the client/3rd-prebuilt
# submodule instead (see src_configure). git-r3's submodule fetch in
# src_unpack happens before any network-sandbox restriction would apply
# anyway, same as any other git-r3 ebuild, so no RESTRICT is needed here.
DEPEND="
	dev-qt/qtbase:6[concurrent,dbus,gui,network,widgets,wayland,xml]
	dev-qt/qt5compat:6
	dev-qt/qtdeclarative:6
	dev-qt/qtremoteobjects:6
	dev-qt/qtsvg:6
	dev-qt/qttools:6
"
RDEPEND="${DEPEND}
	dev-qt/qtshadertools:6
"
BDEPEND="
	dev-qt/qttools:6
"

src_configure() {
	# Dopamine's own client/cmake/3rdparty.cmake hardcodes
	# OPENSSL_LIB_SSL_PATH/OPENSSL_LIB_CRYPTO_PATH/ZLIB_LIB_PATH to prebuilt
	# *.a files under client/3rd-prebuilt/3rd-prebuilt/{openssl,libssh}/
	# (the submodule repo itself nests another "3rd-prebuilt" dir -- not a
	# typo) and sets OPENSSL_USE_STATIC_LIBS TRUE, statically linking that
	# vendored OpenSSL/zlib into the binary unconditionally for every
	# platform, Linux included. These are plain set() calls with no CACHE
	# qualifier, so -D overrides on the cmake command line are silently
	# clobbered -- there's no supported way to point this at the system's
	# dev-libs/openssl and virtual/zlib short of patching
	# client/cmake/3rdparty.cmake directly, which risks subtly changing
	# the VPN crypto behavior upstream built and tested against. Matching
	# upstream's own prebuilt libs exactly (fetched above via
	# EGIT_SUBMODULES) is the safer default; revisit if this overlay ever
	# wants to harden this instead of just tracking upstream.
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
	)
	cmake_src_configure
}

src_install() {
	# No CMake install() rules exist anywhere in this tree at all (grep
	# for yourself) -- upstream's own deploy/build_linux.sh instead
	# downloads a third-party tool (CQtDeployer) to bundle a redistributable,
	# self-contained copy of the Qt runtime next to the binaries, which is
	# both unnecessary (we link dynamically against this system's own Qt6,
	# like any other Gentoo Qt app) and inappropriate (Gentoo packages don't
	# vendor their own copies of shared system libs) for a real install.
	#
	# The client/service split below is NOT just a naming choice, though:
	# WireguardUtilsLinux::wgStart() (client/platforms/linux/daemon/
	# wireguardutilslinux.cpp) spawns the WireGuard tunnel as
	# `QCoreApplication::applicationDirPath() + "/../../client/bin/wireguard-go"`
	# -- i.e. it's hardcoded relative to the *service* binary's own install
	# location, two directories up then into a sibling "client/bin". Install
	# the service anywhere else relative to the client and that exec
	# silently resolves to a nonexistent path, QProcess::start() fails with
	# FailedToStart, and tunnel activation times out exactly like this
	# (real-world symptom this was debugged from):
	#   WireguardUtilsLinux: Tunnel process encountered an error: QProcess::FailedToStart
	#   WireguardUtilsLinux: Unable to start tunnel process due to timeout
	#   Daemon: Interface creation failed.
	# So: client/bin and service/bin must be siblings under the same
	# prefix, matching upstream's own AppDir/{client,service}/bin layout
	# exactly (see deploy/build_linux.sh), not collapsed into one bin/ dir.
	exeinto /opt/Dopamine/client/bin
	newexe "${BUILD_DIR}/client/Dopamine" Dopamine
	exeinto /opt/Dopamine/service/bin
	newexe "${BUILD_DIR}/service/server/dopamine-service" dopamine-service

	# wireguard-go itself (the actual thing missing above) plus the other
	# prebuilt backend binaries/data (tun2socks, ss-local, openvpn,
	# ck-client, geoip.dat, geosite.dat) all live in the same directory
	# upstream's own build_linux.sh copies verbatim into its AppDir;
	# there's no CMake target that builds or stages any of this, it's
	# fetched prebuilt via the client/3rd-prebuilt submodule (see
	# src_configure's comment on that submodule).
	local prebuilt_bin="${S}/client/3rd-prebuilt/deploy-prebuilt/linux/client/bin"
	[[ -d ${prebuilt_bin} ]] || die "prebuilt client/bin dir not found: ${prebuilt_bin}"
	exeinto /opt/Dopamine/client/bin
	doexe "${prebuilt_bin}"/*

	doicon -s 512 "${S}/deploy/data/linux/Dopamine.png"
	make_desktop_entry /opt/Dopamine/client/bin/Dopamine Dopamine Dopamine "Network;Qt;Security"

	# Adapted from deploy/data/linux/Dopamine.service: that unit's
	# LD_LIBRARY_PATH assumed the CQtDeployer-bundled client/lib dir that we
	# don't produce (no LD_LIBRARY_PATH override needed since nothing here
	# is statically-bundled Qt); ExecStart is otherwise unchanged, since
	# service/bin is at the same relative place as upstream's own layout.
	cat <<-EOF > "${T}/Dopamine.service"
		[Unit]
		Description=Dopamine Service
		After=network.target
		StartLimitIntervalSec=0

		[Service]
		Type=simple
		Restart=always
		RestartSec=1
		ExecStart=/opt/Dopamine/service/bin/dopamine-service

		[Install]
		WantedBy=multi-user.target
	EOF
	systemd_dounit "${T}/Dopamine.service"
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
