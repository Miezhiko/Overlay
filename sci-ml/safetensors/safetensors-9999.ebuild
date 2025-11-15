# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1

DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1 cargo git-r3

EGIT_REPO_URI="https://github.com/huggingface/safetensors.git"

DESCRIPTION="Simple, safe way to store and distribute tensors"
HOMEPAGE="
	https://pypi.org/project/safetensors/
	https://huggingface.co/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

QA_FLAGS_IGNORED="usr/lib/.*"
RESTRICT="test" #depends on single pkg ( pytorch )

RDEPEND="
"
BDEPEND="
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
	test? (
		dev-python/h5py[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

S="${WORKDIR}"/${P}/bindings/python

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_prepare() {
	distutils-r1_src_prepare
	rm tests/test_{tf,paddle,flax}_comparison.py || die
	rm benches/test_{pt,tf,paddle,flax}.py || die
}

src_configure() {
	cargo_src_configure
	distutils-r1_src_configure
}

python_compile() {
	cargo_src_compile
	distutils-r1_python_compile
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
}
