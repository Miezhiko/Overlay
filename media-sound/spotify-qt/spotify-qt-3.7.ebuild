# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils desktop cmake-utils

DESCRIPTION="Lightweight Spotify client using Qt"
HOMEPAGE="https://github.com/kraxarn/spotify-qt"
SRC_URI="https://github.com/kraxarn/spotify-qt/archive/v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/designer:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtdbus:5
	dev-qt/qtsvg:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5"
RDEPEND="${DEPEND}"

src_configure() {
  local mycmakeargs=(
    -DUSE_QT_QUICK=OFF
  )

  cmake-utils_src_configure
}

