# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR=ninja

inherit git-r3

DESCRIPTION="High-performance, zero-overhead, extensible Python compiler using LLVM"
HOMEPAGE="https://github.com/exaloop/codon"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE=""

RDEPEND="dev-libs/libfmt"
DEPEND="${RDEPEND}
	dev-util/cmake
	"

RESTRICT=test

CODON_LLVM_DIR="${WORKDIR}/${P}/llvm-project"

src_unpack() {
	EGIT_REPO_URI="https://github.com/exaloop/codon.git"
	EGIT_BRANCH="develop"
	EGIT_SUBMODULES=( '*' )
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	git-r3_src_unpack

	EGIT_REPO_URI="https://github.com/exaloop/llvm-project"
	EGIT_BRANCH="codon"
	EGIT_SUBMODULES=( '*' )
	EGIT_CHECKOUT_DIR="${CODON_LLVM_DIR}"
	git-r3_src_unpack

	cd "${S}"
	cmake -S llvm-project/llvm -B llvm-project/build -G Ninja \
		-DCMAKE_BUILD_TYPE=Release \
		-DLLVM_INCLUDE_TESTS=OFF \
		-DLLVM_ENABLE_RTTI=ON \
		-DLLVM_ENABLE_ZLIB=OFF \
		-DLLVM_ENABLE_TERMINFO=OFF \
		-DLLVM_TARGETS_TO_BUILD=all || die
	cmake --build llvm-project/build || die
	cmake --install llvm-project/build --prefix=llvm-project/install || die
	cmake -S . -B build -G Ninja \
		-DCMAKE_BUILD_TYPE=Release \
		-DLLVM_DIR=$(${CODON_LLVM_DIR}/install/bin/llvm-config --cmakedir) \
		-DCMAKE_C_COMPILER=clang \
		-DCMAKE_CXX_COMPILER=clang++ || die
}

src_configure() {
	:;
}

src_compile() {
	cd "${S}"
	cmake --build build --config Release || die
}

src_install() {
	cd "${S}"
	cmake --install build --prefix=${ED}/usr || die
	rm -rf "${ED}/usr/include/fmt"
	# TODO: get_libdir for 32bit etc
	rm -rf "${ED}/usr/lib64/cmake/fmt"
	rm -f  "${ED}/usr/lib64/pkgconfig/fmt.pc"
}
