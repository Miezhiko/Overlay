# Copyright 2021 Miezhiko
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit git-r3 python-any-r1 desktop xdg wrapper

DESCRIPTION="Alchemy SL Viewer"
HOMEPAGE="https://alchemyviewer.org"
IUSE="system"

# Official source:
#EGIT_REPO_URI="https://git.alchemyviewer.org/alchemy/alchemy-next.git"

# Personal fork:
EGIT_REPO_URI="https://github.com/Miezhiko/Alchemy.git"
EGIT_BRANCH="system"

SLOT="0"
KEYWORDS="~amd64"
LICENSE="LGPLv2"

BDEPEND="${BDEPEND}
	system? (
		dev-cpp/abseil-cpp
		media-libs/freealut
		dev-libs/glh
		dev-libs/uriparser
		media-libs/openjpeg[static-libs]
		net-libs/nghttp2[cxx,static-libs]
		media-libs/libwebp
		app-text/hunspell[static-libs]
		dev-libs/libndofdev
		dev-libs/collada-dom
		x11-libs/pango
	)"

DEPEND="${BDEPEND}
	${DEPEND}
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

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/alchemy-cef.patch
	"${FILESDIR}"/alchemy-desktop.patch
)

src_prepare() {
	virtualenv ".venv" -p python3
	source .venv/bin/activate
	pip3 install --upgrade autobuild -i https://git.alchemyviewer.org/api/v4/projects/54/packages/pypi/simple --extra-index-url https://pypi.org/simple
	default
}

src_configure() {
	autobuild configure -A 64 -c ReleaseOS -- \
		-DLL_TESTS:BOOL=FALSE \
		-DLLCOREHTTP_TESTS=FALSE \
		-DUNIX_DISABLE_FATAL_WARNINGS=ON \
		-DENABLE_MEDIA_PLUGINS=ON \
		-DUSE_VLC=ON \
		-DUSE_X11=ON \
		-DUSE_CEF=ON \
		-DUSE_OPENAL=ON \
		-DEXAMPLEPLUGIN=OFF \
		-DREVISION_FROM_VCS=ON \
		-DUSESYSTEMLIBS=$(usex system ON OFF) \
		-DUSE_FMODSTUDIO=OFF
}

src_compile() {
	autobuild build -A 64 -c ReleaseOS --no-configure
}

src_install() {
	insinto "/opt/alchemy-install"
	doins -r "${WORKDIR}/${P}"/build-linux-64/newview/packaged/*

	fperms +x /opt/alchemy-install/bin/llplugin/chrome-sandbox
	fperms +x /opt/alchemy-install/bin/llplugin/dullahan_host
	fperms +x /opt/alchemy-install/bin/do-not-directly-run-alchemy-bin
	fperms +x /opt/alchemy-install/bin/SLPlugin
	fperms +x /opt/alchemy-install/bin/SLVoice
	fperms +x /opt/alchemy-install/alchemy
	fperms -R +x /opt/alchemy-install/etc/

	make_wrapper alchemy "/opt/alchemy-install/alchemy"

	domenu "${FILESDIR}/alchemy.desktop"
}

pkg_postinst() {
	xdg_pkg_postinst
}
