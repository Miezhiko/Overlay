# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="MIGMA SHELTER"
HOMEPAGE="https://github.com/Miezhiko/Shelter"

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Miezhiko/Shelter.git"
	EGIT_BRANCH="mawa"
else
	SRC_URI="https://github.com/Miezhiko/Shelter/archive/v${PV}.tar.gz"
	S="${WORKDIR}/Shelter-${PV}"
fi

RESTRICT="mirror test"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+lto"

RDEPEND=""
DEPEND="${RDEPEND}"

src_unpack() {
	git-r3_src_unpack
	cd "${S}"
	mkdir build || die
	cd build || die
	cmake -DUSE_LTO=$(usex lto TRUE FALSE) -DCMAKE_BUILD_TYPE=Release .. || die
	make || die
}

src_configure() {
	:;
}

src_compile() {
	:;
}

src_install() {
	dobin "${S}/build/shelter"
}
