# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1 git-r3

EGIT_REPO_URI="https://github.com/Zai-Kun/py-arkose-token-generator.git"
EGIT_BRANCH="main"
SRC_URI=""
KEYWORDS=""

DESCRIPTION="Large Language Model Text Generation Inference"
HOMEPAGE="https://github.com/huggingface/text-generation-inference"

LICENSE="HFOILv1.0"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

KEYWORDS="~amd64 ~x86"

