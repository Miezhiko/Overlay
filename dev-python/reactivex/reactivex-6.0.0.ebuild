# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Upstream's own requires-python floor moved to >=3.11,<4.0 for this
# release (confirmed via the PyPI JSON API's info.requires_python field).
PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=poetry

inherit distutils-r1

DESCRIPTION="A library for composing asynchronous and event-based programs"
HOMEPAGE="https://pypi.org/project/reactivex"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/ReactiveX/RxPY/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"
S="${WORKDIR}/RxPY-${PV}"
