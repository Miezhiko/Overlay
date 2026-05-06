# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs flag-o-matic

Sparse_PV=$(ver_rs 3 '.')
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Common configurations for all packages in suitesparse"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

S="${WORKDIR}/${Sparse_P}/SuiteSparse_config"
LICENSE="BSD"
SLOT="0/7"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="openmp"

# we need to depend on blas as the cmake file looks for it.
# It is also a runtime dependency as it has headers to link with blas
DEPEND="virtual/blas"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	# Make sure we always include the Fortran interface.
	# It doesn't require a Fortran compiler to be present
	# and simplifies the configuration for dependencies.
	# Define SUITESPARSE_INCLUDEDIR_POSTFIX to "" otherwise it take
	# the value suitesparse, and the include directory would be set to
	# /usr/include/suitesparse
	# This need to be set in all suitesparse ebuilds.
	
	# Get the current BLAS implementation via pkg-config
	local blas_libs=$(pkg-config --libs blas 2>/dev/null)
	local lapack_libs=$(pkg-config --libs lapack 2>/dev/null)
	
	# Fallback to eselect blas if pkg-config fails
	if [[ -z ${blas_libs} ]]; then
		local blas_impl=$(readlink -f /usr/lib64/libblas.so 2>/dev/null || readlink -f /usr/lib/libblas.so 2>/dev/null)
		blas_libs="-L$(dirname ${blas_impl}) -lblas"
		lapack_libs="-L$(dirname ${blas_impl}) -llapack"
	fi
	
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=OFF
		-DSUITESPARSE_USE_OPENMP=$(usex openmp ON OFF)
		-DSUITESPARSE_INCLUDEDIR_POSTFIX=""
		-DSUITESPARSE_USE_FORTRAN=ON
		# Disable MKL auto-detection and use system BLAS
		-DBLA_VENDOR="Generic"
		-DBLAS_LIBRARIES="${blas_libs}"
		-DLAPACK_LIBRARIES="${lapack_libs}"
	)
	cmake_src_configure
}
