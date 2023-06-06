# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-build

DESCRIPTION="Virtual for Rust language compiler"

LICENSE=""

SLOT="0/llvm-16"

KEYWORDS=""
IUSE="rustfmt"

BDEPEND=""
RDEPEND="~dev-lang/crab-${PV}[rustfmt?,${MULTILIB_USEDEP}]"
