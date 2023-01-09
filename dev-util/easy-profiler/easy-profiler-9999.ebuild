# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR=ninja

inherit cmake git-r3

DESCRIPTION="Lightweight profiler library for c++"
HOMEPAGE="https://github.com/yse/easy_profiler"
EGIT_REPO_URI="https://github.com/yse/easy_profiler.git"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE=""

RDEPEND="
	dev-qt/designer:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtsql:5
	dev-qt/qtwebkit:5"
DEPEND="${RDEPEND}"

RESTRICT=test

src_install() {
	dobin "${BUILD_DIR}/bin/profiler_gui"
	dobin "${BUILD_DIR}/bin/profiler_reader"
	dolib.so "${BUILD_DIR}/bin/libeasy_profiler.so"
}
