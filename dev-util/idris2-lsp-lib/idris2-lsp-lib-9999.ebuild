# Copyright 1999-2024 Gentoo Authors
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
"
DEPEND="${RDEPEND}"
BDEPEND=""

LSP_PKG="lsp-lib-0.5.0"

src_unpack() {
	git-r3_src_unpack
	cd "${S}" || die
	git submodule update --init LSP-lib || die
}

src_configure() {
	:
}

src_compile() {
	cd "${S}/LSP-lib" || die
	echo compiling lsp-lib
	IDRIS2=/usr/bin/idris2 SCHEME=${SCHEME} idris2 --build || die
}

src_install() {
	cd "${S}/LSP-lib" || die
	IDRIS_DIR=$(/usr/bin/idris2 --libdir)
	PKG_DIR="${ED}/${IDRIS_DIR}/${LSP_PKG}"
	mkdir -p "${PKG_DIR}" || die
	cp -r "${S}/LSP-lib/build/ttc"/* "${PKG_DIR}" || die # installing binaries
	cp -r "${S}/LSP-lib/src"/* "${PKG_DIR}" || die # installing sources
}
