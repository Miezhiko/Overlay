# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-build

DESCRIPTION="Virtual for Rust language compiler"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE="rustfmt"

BDEPEND=""
RDEPEND="~dev-lang/rust-${PV}[rustfmt?,${MULTILIB_USEDEP}]"
