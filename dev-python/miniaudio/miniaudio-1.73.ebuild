# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{14,15} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for miniaudio playback, recording and decoding"
HOMEPAGE="https://github.com/irmen/pyminiaudio"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-python/cffi-1.12.0[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}"

RESTRICT="test"
