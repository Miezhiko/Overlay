# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="LDAC codec library from AOSP"
HOMEPAGE="https://android.googlesource.com/platform/external/libldac/"
SRC_URI="https://github.com/EHfive/ldacBT/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://android.googlesource.com/platform/external/libldac/+archive/eeee1a3f5f8df1282e3a6d297085885fd886737b.tar.gz -> libldac-aosp-${PV}.tar.gz"

S="${WORKDIR}/ldacBT-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"

RESTRICT="mirror"

src_unpack() {
	default

	mkdir -p "${S}/libldac" || die
	cd "${S}/libldac" || die
	# GitHub release tarballs don't include git submodules.
	# CMakeLists.txt expects sources under libldac/src/, libldac/inc/, etc.
	tar -xzf "${DISTDIR}/libldac-aosp-${PV}.tar.gz" || die
}

multilib_src_configure() {
	local mycmakeargs=(
		-DLDAC_SOFT_FLOAT=OFF
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
	)

	cmake_src_configure
}
