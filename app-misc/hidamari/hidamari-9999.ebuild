# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..14} )

DISTUTILS_USE_PEP517=poetry

inherit git-r3 distutils-r1 meson

DESCRIPTION="Video wallpaper for Linux."

# using fork for some fixes!111
EGIT_REPO_URI="https://github.com/Masha/hidamari.git"
EGIT_BRANCH="mawa"
EGIT_SUBMODULES=()

HOMEPAGE="https://github.com/Masha/hidamari"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	dev-libs/libayatana-appindicator
	x11-apps/mesa-progs
	net-misc/yt-dlp[${PYTHON_USEDEP}]
	dev-python/pydbus[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
	dev-python/python-vlc[${PYTHON_USEDEP}]
	"

