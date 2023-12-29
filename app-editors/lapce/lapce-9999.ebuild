# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo git-r3 desktop

EGIT_REPO_URI="https://github.com/lapce/lapce.git"
DESCRIPTION="Lightning-fast and Powerful Code Editor written in Rust"
HOMEPAGE="https://github.com/lapce/lapce"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions"
RESTRICT="mirror"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-lang/rust-1.70.0"
RDEPEND="${DEPEND}"

src_unpack() {
	git-r3_src_unpack
	cd "${WORKDIR}/${P}"
	cargo update
	cd "${WORKDIR}"
	cargo_live_src_unpack
}

src_install() {
	cargo_src_install
	domenu "${FILESDIR}/lapce.desktop"
}
