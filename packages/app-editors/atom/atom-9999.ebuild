# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit git-r3 flag-o-matic python-any-r1 eutils desktop

DESCRIPTION="A hackable text editor for the 21st Century"
HOMEPAGE="https://atom.io/"
SRC_URI=""

EGIT_REPO_URI="https://github.com/atom/atom"
EGIT_COMMIT="c7bf8f1aa3084b107cecf4c727c1f087de89b4ad"
EGIT_COMMIT_SHORT="c7bf8f1aa"
TMP_PATH="${WORKDIR}/atom-9999/out/atom-dev-1.57.0-dev-${EGIT_COMMIT_SHORT}-amd64"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64"
IUSE=""

DEPEND="
	${PYTHON_DEPS}
	net-libs/nodejs[npm]
	media-fonts/inconsolata[X]
	x11-libs/gtk+:2
	x11-libs/libnotify
	x11-libs/libXtst
	dev-libs/nss
"
RDEPEND="${DEPEND}"

pkg_setup() {
	python-any-r1_pkg_setup
	npm config set python "${PYTHON}"
}

src_unpack() {
	git-r3_src_unpack
}

src_prepare(){
	sed -i \
		-e "1a\export PYTHON=${PYTHON}\n" \
		atom.sh

	sed \
		-e "s/<%= description %>/$pkgdesc/" \
		-e "s|<%= installDir %>/share/<%= appFileName %>/atom|/usr/bin/atom|" \
		-e "s|<%= iconPath %>|atom|" \
		-e "s|<%= appName %>|Atom|" \
		resources/linux/atom.desktop.in > resources/linux/Atom.desktop

	# Fix atom location guessing
	sed -i \
		-e 's/ATOM_PATH="$USR_DIRECTORY\/share\/atom/ATOM_PATH="$USR_DIRECTORY\/../g' \
		./atom.sh || die "Fail fixing atom-shell directory"

	# Make bootstrap process more verbose
	sed -i \
		-e 's@node script/bootstrap@node script/bootstrap --no-quiet@g' \
		./script/build || die "Fail fixing verbosity of script/build"

	default
}

src_compile() {
	./script/build --verbose --build-dir "${T}" || die "Failed to compile"
	"${TMP_PATH}/resources/app/apm/bin/apm" rebuild || die "Failed to rebuild native module"
	echo "python = $PYTHON" >> "${TMP_PATH}/resources/app/apm/.apmrc"
}

src_install() {
	insinto "/usr/share/${PN}"
	doins -r "${TMP_PATH}"/*
	insinto "/usr/share/applications"
	newins "resources/linux/Atom.desktop" "atom.desktop"
	insinto "/usr/share/pixmaps"
	newins "resources/app-icons/stable/png/128.png" "atom.png"
	insinto "/usr/share/licenses/${PN}"
	doins LICENSE.md
	# Fixes permissions
	fperms +x "${EPREFIX}/usr/share/${PN}/${PN}"
	fperms +x "${EPREFIX}/usr/share/${PN}/libEGL.so"
	fperms +x "${EPREFIX}/usr/share/${PN}/libvk_swiftshader.so"
	fperms +x "${EPREFIX}/usr/share/${PN}/libffmpeg.so"
	fperms +x "${EPREFIX}/usr/share/${PN}/libvulkan.so"
	fperms +x "${EPREFIX}/usr/share/${PN}/libGLESv2.so"
	fperms +x "${EPREFIX}/usr/share/${PN}/resources/app/atom.sh"
	fperms +x "${EPREFIX}/usr/share/${PN}/resources/app/apm/bin/apm"
	fperms +x "${EPREFIX}/usr/share/${PN}/resources/app/apm/bin/node"
	fperms +x "${EPREFIX}/usr/share/${PN}/resources/app/apm/bin/npm"
	# Symlinking to /usr/bin
	dosym "${EPREFIX}/usr/share/${PN}/resources/app/atom.sh" /usr/bin/atom
	dosym "${EPREFIX}/usr/share/${PN}/resources/app/apm/bin/apm" /usr/bin/apm

  make_wrapper Atom "/usr/share/atom/resources/app/atom.sh --no-sandbox"
  #make_desktop_entry "atom" "atom" "atom" "Development;IDE"
}
