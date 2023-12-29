# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR=emake

inherit cmake

DESCRIPTION="Discord RPC lib"
HOMEPAGE="https://github.com/discordapp/discord-rpc"
SRC_URI="https://github.com/discordapp/discord-rpc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-libs/rapidjson"
RDEPEND="${DEPEND}"

src_prepare() {
	sed 's:Werror:fpic:g' -i "${S}/src/CMakeLists.txt"
	cmake_src_prepare
	eapply_user
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=OFF
	)
	cmake_src_configure
}

