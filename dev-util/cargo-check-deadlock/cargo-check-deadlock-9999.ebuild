# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo git-r3

EGIT_REPO_URI="https://github.com/hlisdero/cargo-check-deadlock.git"
DESCRIPTION="Find deadlocks in Rust code with Petri net model checking"
HOMEPAGE="https://github.com/hlisdero/cargo-check-deadlock"

LICENSE="Apache-2.0"
RESTRICT="mirror"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-lang/rust-1.64.0"
RDEPEND="${DEPEND}"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}
