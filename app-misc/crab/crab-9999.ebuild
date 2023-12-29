# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="a crab"
HOMEPAGE="https://github.com/Miezhiko/crab"

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Miezhiko/crab.git"
	EGIT_BRANCH="mawa"
else
	SRC_URI="https://github.com/Miezhiko/crab/archive/v${PV}.tar.gz"
	S="${WORKDIR}/crab-${PV}"
fi

RESTRICT="mirror test"
LICENSE="GPLv3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""

src_configure() {
	:;
}

src_compile() {
	:;
}

src_install() {
	dobin "${S}/crab"
}
