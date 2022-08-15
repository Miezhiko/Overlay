# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A glossy client for Matrix, written in QtQuick Controls 2 and C++."
HOMEPAGE="https://gitlab.com/b0/spectral"

inherit cmake

if [[ ${PV} == "9999" ]]; then
	inherit git-r3

	SRC_URI=""
	EGIT_REPO_URI="https://gitlab.com/b0/spectral.git"
	EGIT_SUBMODULES=("include/SortFilterProxyModel")
else
	SRC_URI="https://gitlab.com/b0/spectral/-/archive/${PV}/${PN}.tar.gz -> ${P}.tar.gz"
fi

KEYWORDS="~amd64 ~x86"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="app-text/cmark
	dev-qt/qtgui
	dev-qt/qtmultimedia[qml]
	dev-qt/qtwidgets
	>=dev-qt/qtquickcontrols2-5.12
	>dev-libs/libQuotient-0.5.1.2
	dev-libs/libQtOlm
	media-fonts/noto-emoji
  dev-libs/qtkeychain
"

DEPEND="${RDEPEND}
	>=dev-qt/qtcore-5.12
"

src_configure() {
	local mycmakeargs=(
		-DUSE_INTREE_LIBQMC=OFF
	)
	cmake_src_configure
}
