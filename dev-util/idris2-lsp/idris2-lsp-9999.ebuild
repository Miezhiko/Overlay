# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Language Server for Idris2"
HOMEPAGE="https://github.com/idris-community/idris2-lsp"

EGIT_REPO_URI="https://github.com/idris-community/idris2-lsp.git"
EGIT_SUBMODULES=()

KEYWORDS="~amd64"

LICENSE="BSD"
SLOT="0"
IUSE=""
REQUIRED_USE=""

RDEPEND="
	dev-lang/idris2
	=dev-util/idris2-lsp-lib-${PV}
"
DEPEND="${RDEPEND}"
BDEPEND=""

src_configure() {
	:
}

src_install() {
	cd "${S}" || die
	IDRIS_DIR=$(/usr/bin/idris2 --libdir)
	APP_DIR="${ED}/usr/lib/idris2/bin/"
	mkdir -p "${APP_DIR}" || die
	cp -r "${S}/build/exec"/* "${APP_DIR}/" || die

	PKG_DIR="${ED}/${IDRIS_DIR}/${P}"
	mkdir -p "${PKG_DIR}" || die
	cp -r "${S}/build/ttc"/* "${PKG_DIR}" || die # installing binaries
	cp -r "${S}/src"/* "${PKG_DIR}" || die # installing sources

	dosym "/usr/lib/idris2/bin/${PN}" "/usr/bin/${PN}"
}
