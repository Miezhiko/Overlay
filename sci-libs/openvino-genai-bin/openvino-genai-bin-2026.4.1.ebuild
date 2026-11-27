# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The upstream archive ships extension modules through CPython 3.13.
PYTHON_COMPAT=( python3_{11..13} )
inherit python-single-r1

DESCRIPTION="OpenVINO GenAI SDK and runtime with Intel NPU support"
HOMEPAGE="https://github.com/openvinotoolkit/openvino.genai"
MY_P="openvino_genai_ubuntu26_${PV}.0_x86_64"
SRC_URI="https://storage.openvinotoolkit.org/repositories/openvino_genai/packages/${PV}/linux/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0 Intel-OpenVINO"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="strip"

RDEPEND="
	~dev-libs/intel-npu-driver-bin-1.39.1
	dev-libs/opencl-icd-loader
	app-arch/zstd
	>=sys-libs/glibc-2.43
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-python/numpy[${PYTHON_USEDEP}]')
	)
"

QA_PREBUILT="opt/openvino-genai/*"

pkg_setup() {
	if use python; then
		python-single-r1_pkg_setup
	fi
}

src_install() {
	insinto /opt/openvino-genai
	doins -r runtime
	doins setupvars.sh
	dodoc docs/licensing/{EULA.txt,LICENSE,LICENSE-GENAI,*third-party-programs.txt}
	newdoc docs/openvino_tokenizers/LICENSE LICENSE-Tokenizers
	newdoc docs/openvino_tokenizers/third-party-programs.txt tokenizers-third-party-programs.txt

	if use python; then
		local abi="${EPYTHON#python}"
		find python -type f -name '*.cpython-*.so' \
			! -name "*.cpython-${abi/./}-*.so" -delete || die
		# The archive ships a JAX binding without its native frontend.
		rm -r python/openvino/frontend/jax || die
		doins -r python
		cat > "${T}/openvino-genai-python" <<-'WRAPPER' || die
			#!/bin/sh
			root=/opt/openvino-genai
			export LD_LIBRARY_PATH="$root/runtime/lib/intel64:$root/runtime/3rdparty/tbb/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
			export PYTHONPATH="$root/python${PYTHONPATH:+:$PYTHONPATH}"
			exec @PYTHON@ "$@"
		WRAPPER
		sed -i "s|@PYTHON@|${PYTHON}|" "${T}/openvino-genai-python" || die
		dobin "${T}/openvino-genai-python"
	fi
}
