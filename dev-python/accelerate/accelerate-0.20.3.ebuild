# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="${PN}"
HOMEPAGE="https://pypi.org/project/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

KEYWORDS="~amd64 ~x86"

SRC_URI="https://github.com/huggingface/accelerate/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

