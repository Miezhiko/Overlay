# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR=emake

inherit cmake git-r3

DESCRIPTION="Anonymous, decentralized and IP based overlay network for the internet"
HOMEPAGE="https://github.com/oxen-io/lokinet"

EGIT_REPO_URI="https://github.com/oxen-io/lokinet.git"
EGIT_BRANCH="dev"
KEYWORDS="~amd64"

LICENSE="GPL-3"
SLOT="0"

IUSE="systemd +lto"

BDEPEND="virtual/pkgconfig"
CDEPEND="
	dev-libs/libsodium
	net-libs/cppzmq
	dev-libs/libuv
	net-dns/unbound
	dev-db/sqlite
"
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}"

src_unpack() {
	git-r3_src_unpack
	mkdir -p "${BUILD_DIR}" || die
	cd ${BUILD_DIR}
	xdg_environment_reset
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DBUILD_SHARED_LIBS=OFF
		-DQXENMQ_INSTALL_CPPZMQ=OFF
		-DQXENMQ_LOKIMQ_COMPAT=OFF
		-DJSON_Install=OFF
		-DCXXOPTS_BUILD_TESTS=OFF
		-DBUILD_TESTING=OFF
		-DWITH_SYSTEMD="$(usex systemd)"
		-DWITH_LTO="$(usex lto)"
	)
	local cmakeargs=(
		-G "Unix Makefiles"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		"${mycmakeargs[@]}"
	)
	"${CMAKE_BINARY}" "${cmakeargs[@]}" "${S}" || die "cmake failed"
	emake
}

src_prepare() {
	default
}

src_configure() {
	:;
}

src_compile() {
	:;
}

src_install() {
	cd ${BUILD_DIR}
	DESTDIR="${D}" emake install
}
