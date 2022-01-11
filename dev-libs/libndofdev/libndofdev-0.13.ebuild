# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="Replacement for the libndofdev library used by the Second Life client to handle joysticks and the 6DOF devices on Windows and Macs."
HOMEPAGE="https://github.com/janoc/libndofdev"
SRC_URI="https://github.com/janoc/libndofdev/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="media-libs/libsdl"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}"

src_compile() {
    emake CFLAGS="${CFLAGS}"
}

src_install() {
    dobin ndofdev_test
    dolib.a libndofdev.a
    insinto usr/include
    doins ndofdev_external.h
}
