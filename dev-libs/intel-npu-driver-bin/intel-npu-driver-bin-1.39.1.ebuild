# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib toolchain-funcs

DESCRIPTION="Intel Level Zero NPU user-mode driver and matching compiler"
HOMEPAGE="https://github.com/intel/linux-npu-driver"
BUILD_ID="${PV}.20261119-44517102376"
SRC_URI="https://github.com/intel/linux-npu-driver/releases/download/v${PV}/linux-npu-driver-v${BUILD_ID}-ubuntu2404.tar.gz"
S="${WORKDIR}/payload"

LICENSE="MIT BSD Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="strip"

RDEPEND="
	>=dev-libs/level-zero-1.34.0
	dev-cpp/tbb:0
	app-arch/zstd
	sys-libs/zlib
	>=sys-libs/glibc-2.38
"

QA_PREBUILT="usr/lib64/libze_intel_npu.so* usr/lib64/libopenvino_intel_npu_compiler*.so"

src_unpack() {
	default
	mkdir -p "${S}" || die
	local package member
	for package in intel-level-zero-npu intel-driver-compiler-npu; do
		member="${WORKDIR}/${package}_${BUILD_ID}~ubuntu24.04_amd64.deb"
		$(tc-getAR) p "${member}" data.tar.gz > "${T}/${package}.tar.gz" || die
		tar --no-same-owner -xzf "${T}/${package}.tar.gz" -C "${S}" || die
	done
}

src_install() {
	into /usr
	dolib.so usr/lib/x86_64-linux-gnu/*.so*
}
