# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=" "
inherit cargo git-r3

DESCRIPTION="Forge: AI-Enhanced Terminal Development Environment"
HOMEPAGE="https://forgecode.dev"
EGIT_REPO_URI="https://github.com/tailcallhq/forgecode.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-db/sqlite:3
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
	dev-build/cmake
	dev-lang/nasm
	dev-lang/perl
	dev-libs/protobuf
"

QA_FLAGS_IGNORED="usr/bin/forge"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_configure() {
	cargo_src_configure
}

src_install() {
	cargo_src_install --path crates/forge_main
}
