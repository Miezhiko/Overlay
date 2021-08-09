# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KEYWORDS="~amd64"

DESCRIPTION="MIGMA SHELTER"
HOMEPAGE="https://github.com/Qeenon/Shelter"

inherit cmake-utils

CMAKE_MAKEFILE_GENERATOR=emake

if [[ ${PV} = 9999 ]]; then
  inherit git-r3
  EGIT_REPO_URI="https://github.com/Qeenon/Shelter.git"
  EGIT_BRANCH="mawa"
else
  SRC_URI="https://github.com/Qeenon/Shelter/archive/v${PV}.tar.gz"
  S="${WORKDIR}/Shelter-${PV}"
fi

RESTRICT="mirror test"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}
  dev-util/cmake
"

src_install() {
	dobin "${BUILD_DIR}/shelter"
}
