# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo git-r3

EGIT_REPO_URI="https://github.com/TimonPost/cargo-dependency-inheritor.git"
DESCRIPTION="Utility to inherit dependencies from workspace"
HOMEPAGE="https://github.com/TimonPost/cargo-dependency-inheritor"

LICENSE="Apache-2.0"
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
