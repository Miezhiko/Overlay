# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Minimal Xml parser and printer for OCaml"
HOMEPAGE="http://tech.motion-twin.com/xmllight.html"
SRC_URI="https://github.com/ncannasse/xml-light/releases/download/${PV}/${P}.tbz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv x86"
IUSE="doc +ocamlopt"

RDEPEND="dev-lang/ocaml:=[ocamlopt?]"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip
	dev-ml/dune"

