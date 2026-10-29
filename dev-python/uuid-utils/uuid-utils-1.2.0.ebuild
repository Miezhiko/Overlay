# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="fast uuid utils"
HOMEPAGE="
	https://pypi.org/project/uuid-utils
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv ~sparc x86"
RESTRICT="network-sandbox"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
