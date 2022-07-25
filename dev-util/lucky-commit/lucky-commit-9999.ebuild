# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo git-r3

EGIT_REPO_URI="https://github.com/not-an-aardvark/lucky-commit.git"
DESCRIPTION="Customize your git commit hashes!"
HOMEPAGE="https://github.com/not-an-aardvark/lucky-commit"

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
