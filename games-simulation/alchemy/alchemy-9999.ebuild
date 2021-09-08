# Copyright 2021 Miezhiko
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7..10} )

inherit git-r3 python-any-r1

DESCRIPTION="Alchemy SL Viewer"
HOMEPAGE="https://alchemyviewer.org"

EGIT_REPO_URI="https://git.alchemyviewer.org/alchemy/alchemy-next.git"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${DEPEND}
  media-libs/libpng
  sys-libs/zlib
  dev-libs/boost
  dev-util/cmake
  gui-libs/gtk
  media-libs/mesa
  media-libs/libsdl2
  dev-perl/XML-XPath
  media-libs/openjpeg
  media-video/vlc
  dev-python/pip
  dev-python/virtualenv
  "

src_prepare() {
  cd "${WORKDIR}"
  virtualenv ".venv" -p python3
  source .venv/bin/activate
  pip3 install --upgrade autobuild -i https://git.alchemyviewer.org/api/v4/projects/54/packages/pypi/simple --extra-index-url https://pypi.org/simple
  default
}

src_configure() {
  autobuild configure -A 64 -c ReleaseOS -- -DLL_TESTS:BOOL=FALSE -DUNIX_DISABLE_FATAL_WARNINGS=ON -DREVISION_FROM_VCS=ON -DUSE_FMODSTUDIO=OFF
}

src_compile() {
	autobuild build -A 64 -c ReleaseOS --no-configure
}

src_install() {
  insinto "/opt/${PN}"
  doins -r "${WORKDIR}"/build-linux-64/newview/packaged/*
}

