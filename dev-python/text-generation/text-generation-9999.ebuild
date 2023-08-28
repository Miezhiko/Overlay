# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1 cargo git-r3

EGIT_REPO_URI="https://github.com/huggingface/text-generation-inference.git"
EGIT_BRANCH="main"
SRC_URI=""
KEYWORDS=""

DESCRIPTION="Large Language Model Text Generation Inference"
HOMEPAGE="https://github.com/huggingface/text-generation-inference"

LICENSE="HFOILv1.0"
SLOT="0"
IUSE=""

RDEPEND="dev-python/pydantic"
DEPEND="${RDEPEND}"

KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"/${P}/clients/python

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
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
