# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="An enhanced port of Genesis Plus - accurate & portable Sega 8/16 bit emulator (highscore plugin)"
HOMEPAGE="https://github.com/highscore-emu/Genesis-Plus-GX"

COMMIT="0066f3c387a5b886511991352991bcad485c9a9a"
SRC_URI="https://github.com/highscore-emu/Genesis-Plus-GX/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Genesis-Plus-GX-${COMMIT}"

LICENSE="XMAME"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-arch/zstd:=
	games-emulation/highscore
	media-libs/flac:=
	media-libs/libchdr:=
	media-libs/libvorbis:=
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/meson
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
	)
	EMESON_SOURCE="${S}/highscore" meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}
