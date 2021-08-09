# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo git-r3

EGIT_REPO_URI="https://github.com/rust-analyzer/rust-analyzer"
DESCRIPTION="An experimental Rust compiler front-end for IDEs"
HOMEPAGE="https://rust-analyzer.github.io"

LICENSE="BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions Boost-1.0 CC0-1.0 ISC MIT Unlicense ZLIB"
RESTRICT="mirror"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-lang/rust-1.50.0[rls]"
RDEPEND="${DEPEND}"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_install() {
	cargo_src_install --path "./crates/rust-analyzer"
}
