# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="The Oil Runtime Compiler, a just-in-time compiler for array operations"
HOMEPAGE="https://gstreamer.freedesktop.org/ https://gitlab.freedesktop.org/gstreamer/orc"
SRC_URI="https://gstreamer.freedesktop.org/src/${PN}/${P}.tar.xz"

LICENSE="BSD BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv x86 ~x64-macos ~x64-solaris"
RESTRICT="!test? ( test )"
IUSE="static-libs test"

BDEPEND=""

multilib_src_configure() {
	local emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)
		-Dorc-target=all
		-Dorc-test=enabled
		-Dbenchmarks=disabled
		-Dexamples=disabled
		$(meson_feature test tests)
		-Dtools=enabled # requires orc-test
	)
	meson_src_configure
}
