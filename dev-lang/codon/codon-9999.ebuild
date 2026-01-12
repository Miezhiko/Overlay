# Copyright 1999-2026 Gentoo Authors
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
DEPEND="${RDEPEND}"

BDEPEND="dev-build/ninja
	net-misc/wget"

RESTRICT="test network-sandbox"

CODON_LLVM_DIR="${WORKDIR}/llvm-project"

src_unpack() {
	# Clone main Codon repository
	EGIT_REPO_URI="https://github.com/exaloop/codon.git"
	EGIT_BRANCH="develop"
	EGIT_SUBMODULES=( '*' )
	EGIT_CHECKOUT_DIR="${S}"
	git-r3_src_unpack

	# Clone LLVM fork
	EGIT_REPO_URI="https://github.com/exaloop/llvm-project"
	EGIT_BRANCH="codon"
	EGIT_SUBMODULES=()
	EGIT_CHECKOUT_DIR="${CODON_LLVM_DIR}"
	git-r3_src_unpack

	# Download CPM.cmake
	einfo "Downloading CPM.cmake..."
	mkdir -p "${S}/cmake" || die
	wget -q https://github.com/cpm-cmake/CPM.cmake/releases/latest/download/get_cpm.cmake \
		-O "${S}/cmake/CPM.cmake" || die "Failed to download CPM.cmake"

	# Set CODON_SYSTEM_LIBRARIES as per the guide
	# this one for gcc 15...
	export CODON_SYSTEM_LIBRARIES="/usr/lib/gcc/x86_64-pc-linux-gnu/15/"

	# Build LLVM with clang and OpenMP
	einfo "Building LLVM with clang and OpenMP..."
	cd "${WORKDIR}" || die
	cmake -S "${CODON_LLVM_DIR}/llvm" -B "${CODON_LLVM_DIR}/build" -G Ninja \
		-DCMAKE_BUILD_TYPE=Release \
		-DLLVM_INCLUDE_TESTS=OFF \
		-DLLVM_ENABLE_RTTI=ON \
		-DLLVM_ENABLE_ZLIB=OFF \
		-DLLVM_ENABLE_ZSTD=OFF \
		-DLLVM_ENABLE_TERMINFO=OFF \
		-DLLVM_ENABLE_PROJECTS="clang;openmp" \
		-DLLVM_TARGETS_TO_BUILD=all || die "LLVM CMake configuration failed"

	cmake --build "${CODON_LLVM_DIR}/build" || die "LLVM build failed"
	cmake --install "${CODON_LLVM_DIR}/build" --prefix="${CODON_LLVM_DIR}/install" || die "LLVM install failed"

	# Configure and build Codon (must be done here to allow CPM to download dependencies)
	einfo "Configuring Codon..."
	cd "${S}" || die
	cmake -S . -B build -G Ninja \
		-DCMAKE_BUILD_TYPE=Release \
		-DLLVM_DIR="${CODON_LLVM_DIR}/install/lib/cmake/llvm" \
		-DCMAKE_C_COMPILER=clang \
		-DCMAKE_CXX_COMPILER=clang++ || die "Codon CMake configuration failed"

	einfo "Building Codon..."
	cmake --build build --config Release || die "Codon build failed"
}

src_configure() {
	# Configuration already done in src_unpack
	:
}

src_compile() {
	# Compilation already done in src_unpack
	:
}

src_install() {
	cd "${S}" || die
	DESTDIR="${D}" cmake --install build --prefix=/usr || die "Codon install failed"

	# Remove bundled fmt files (use system fmt instead)
	rm -rf "${ED}/usr/include/fmt" || die
	rm -rf "${ED}/usr/$(get_libdir)/cmake/fmt" || die
	rm -f "${ED}/usr/$(get_libdir)/pkgconfig/fmt.pc" || die
}
