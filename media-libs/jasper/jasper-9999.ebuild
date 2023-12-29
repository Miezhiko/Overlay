# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Implementation of the codec specified in the JPEG-2000 Part-1 standard"
HOMEPAGE="https://www.ece.uvic.ca/~mdadams/jasper/"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mdadams/jasper.git"
	KEYWORDS="~amd64"
else
	inherit vcs-snapshot
	SRC_URI="https://github.com/mdadams/${PN}/archive/version-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
fi

# We limit memory usage to 128 MiB by default, specified in bytes
: ${JASPER_MEM_LIMIT:=134217728}

LICENSE="JasPer2.0"
SLOT="0/4"
IUSE="doc jpeg opengl test"

RDEPEND="
	jpeg? ( >=virtual/jpeg-0-r2:0 )
	opengl? (
		>=virtual/opengl-7.0-r1:0
		>=media-libs/freeglut-2.8.1:0
		virtual/glu
		x11-libs/libXi
		x11-libs/libXmu
	)"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_configure() {
	local mycmakeargs=(
		-DALLOW_IN_SOURCE_BUILD=OFF
		-DBASH_PROGRAM="${EPREFIX}"/bin/bash
		-DJAS_ENABLE_ASAN=OFF
		-DJAS_ENABLE_LSAN=OFF
		-DJAS_ENABLE_MSAN=OFF
		-DJAS_ENABLE_SHARED=ON
		-DJAS_ENABLE_STRICT=ON
		-DJAS_ENABLE_USAN=OFF
		-DCMAKE_INSTALL_DOCDIR=share/doc/${PF}

		# JPEG
		-DJAS_ENABLE_LIBJPEG=$(usex jpeg)
		-DCMAKE_DISABLE_FIND_PACKAGE_JPEG=$(usex !jpeg)

		# OpenGL
		-DJAS_ENABLE_OPENGL=$(usex opengl)
		-DCMAKE_DISABLE_FIND_PACKAGE_OpenGL=$(usex !opengl)

		# Doxygen
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=$(usex doc OFF ON)

		#-DJAS_ENABLE_PROGRAMS=$(usex test)
	)
	cmake_src_configure
}
