# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Anonymous, decentralized and IP based overlay network for the internet"
HOMEPAGE="https://github.com/oxen-io/lokinet"

EGIT_REPO_URI="https://github.com/oxen-io/lokinet.git"
EGIT_BRANCH="dev"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-3"
SLOT="0"

IUSE=""

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

src_prepare() {
	cmake_src_prepare
	default
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DBUILD_SHARED_LIBS=OFF
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
}
