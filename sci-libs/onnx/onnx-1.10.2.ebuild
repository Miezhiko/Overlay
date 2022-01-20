# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

DISTUTILS_OPTIONAL=1

inherit cmake distutils-r1

DESCRIPTION="Open Neural Network Exchange"
HOMEPAGE="https://onnx.ai"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+python test"

DEPEND="
	dev-libs/protobuf:0=
	python? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/protobuf-python[${PYTHON_USEDEP}]
		dev-python/pybind11[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	)"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-use-system-wide-pybind11.patch" )

src_prepare() {
	if use python; then
		sed -i -e "/pytest-runner/d" setup.py || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DONNX_BUILD_TESTS=$(usex test ON OFF)
	)

	cmake_src_configure

	use python && distutils-r1_src_configure
}

src_compile() {
	cmake_src_compile

	use python && distutils-r1_src_compile
}

src_install() {
	cmake_src_install

	use python && distutils-r1_src_install

	local multilib_failing_files=(
		libonnxifi.so
	)

	for file in ${multilib_failing_files[@]}; do
		mv -f "${ED}/usr/lib/${file}" "${ED}/usr/$(get_libdir)"
	done

	fix_python_script_utils() {
		python_setup
		python_get_scriptdir
		python_get_sitedir

		ln -rnsvf "${D}/${PYTHON_SCRIPTDIR}/backend-test-tools" "${D}/usr/bin/" || die
		ln -rnsvf "${D}/${PYTHON_SCRIPTDIR}/check-model" "${D}/usr/bin/" || die
		ln -rnsvf "${D}/${PYTHON_SCRIPTDIR}/check-node" "${D}/usr/bin/" || die
	}

	use python && fix_python_script_utils
}
