# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit cmake-multilib python-any-r1

DESCRIPTION="Abseil Common Libraries (C++), LTS Branch"
HOMEPAGE="https://abseil.io/"
SRC_URI="https://github.com/abseil/abseil-cpp/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV%%.*}.0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="test"

DEPEND=""
RDEPEND="${DEPEND}"

BDEPEND="
	${PYTHON_DEPS}
	test? (
		>=dev-cpp/gtest-1.13.0
		sys-libs/timezone-data
	)
"

RESTRICT="!test? ( test )"

src_prepare() {
	cmake_src_prepare

	# un-hardcode abseil compiler flags
	sed -i \
		-e '/"-maes",/d' \
		-e '/"-msse4.1",/d' \
		-e '/"-mfpu=neon"/d' \
		-e '/"-march=armv8-a+crypto"/d' \
		absl/copts/copts.py || die

	# now generate cmake files
	python_fix_shebang absl/copts/generate_copts.py
	absl/copts/generate_copts.py || die
}

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_CXX_STANDARD=14
		-DABSL_CXX_STANDARD=14
		-DABSL_PROPAGATE_CXX_STD=ON
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
		-DABSL_ENABLE_INSTALL=ON
		-DABSL_USE_EXTERNAL_GOOGLETEST=ON
		-DBUILD_SHARED_LIBS=ON
		-DCMAKE_MODULE_LINKER_FLAGS="-Wl,--no-undefined -Wl,--no-undefined"
		-DABSL_BUILD_TEST_HELPERS=$(usex test ON OFF)
		-DABSL_BUILD_TESTING=$(usex test ON OFF)
		$(usex test -DBUILD_TESTING=ON '') # intentional usex, it used both variables for tests.
	)

	cmake_src_configure
}
