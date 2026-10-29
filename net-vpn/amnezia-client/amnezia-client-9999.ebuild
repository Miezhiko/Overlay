# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# conan-center-index's lzo/2.10 recipe fetches straight from
# oberhumer.com's own tiny personal mirror at conan-install time, which
# routinely answers real, fully-connected HTTP requests with a bare
# "501 Not Implemented" (reproduced directly with the same request Conan
# makes; not a DNS/connectivity problem, the one-person server itself is
# just unreliable). Conan's "sources backup cache" feature lets us hand it
# this file locally, keyed by the sha256 its own conandata.yml already
# expects, which skips that flaky request entirely -- see src_unpack/
# src_configure. Pinned to lzo/2.10's one known conandata.yml entry.
LZO_SHA256="c0f892943208266f9b6543b3ae308fab6284c5c90e627931446fb49b4221a072"

inherit cmake desktop git-r3 systemd xdg

DESCRIPTION="VPN client that resists DPI detection and censorship"
HOMEPAGE="https://amnezia.org"

EGIT_REPO_URI="https://github.com/amnezia-vpn/amnezia-client.git"
EGIT_BRANCH="dev"
# Only the two submodules actually needed on Linux: amneziawg-apple and
# qtgamepad are Apple/mobile-only and aren't touched by this build.
EGIT_SUBMODULES=( "client/3rd/qtkeychain" "client/3rd/SortFilterProxyModel" )

SRC_URI="http://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

# Upstream's build system drives Conan from CMakeLists.txt (conan_provider.cmake)
# to fetch/build 3rd-party deps (openssl, zlib, lz4, ...) that aren't vendored
# in the tarball. This needs network access during src_configure/src_compile,
# which Portage blocks by default under FEATURES=network-sandbox.
RESTRICT="network-sandbox"

DEPEND="
	dev-qt/qtbase:6[concurrent,dbus,gui,network,widgets,wayland,xml]
	dev-qt/qt5compat:6
	dev-qt/qtdeclarative:6
	dev-qt/qthttpserver:6
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
	git-r3_src_unpack

	# Seed Conan's local sources backup cache (see LZO_SHA256 above) so its
	# own conan-center-index recipe never has to touch oberhumer.com itself.
	# (The tarball only needs to exist in DISTDIR, not be unpacked here.)
	mkdir -p "${WORKDIR}/conan-sources-cache/s" || die
	cp "${DISTDIR}/lzo-2.10.tar.gz" \
		"${WORKDIR}/conan-sources-cache/s/${LZO_SHA256}" || die
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

	# See LZO_SHA256/src_unpack above.
	echo "core.sources:download_cache=${WORKDIR}/conan-sources-cache" \
		>> "$(conan config home)/global.conf" || die "failed to enable sources download cache conf"

	# Conan 2.24's bundled settings.yml only knows compilers up to
	# gcc 15 / clang 21; conan profile detect and conan_provider.cmake
	# record the real major (gcc 16 / clang 23) and Conan rejects it:
	#   ERROR: Invalid setting '23' is not a valid
	#          'settings.compiler.version' value.
	# settings_user.yml is merged on top of settings.yml, so extend the
	# accepted version lists. ${HOME} is ${PORTAGE_BUILDDIR}/homedir
	# (fresh per build), so rewrite it every configure.
	local conan_home
	conan_home="$(conan config home)" || die "conan config home failed"
	cat > "${conan_home}/settings_user.yml" <<-EOF || die "failed to write settings_user.yml"
		compiler:
		    gcc:
		        version: ["16", "16.1", "16.2"]
		    clang:
		        version: ["22", "23"]
	EOF

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
