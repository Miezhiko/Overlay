# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..12} pypy3 )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

SRC_URI="https://github.com/yifeikong/curl_cffi/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/curl_cffi-${PV}"

DESCRIPTION="Python binding for curl-impersonate via cffi"
HOMEPAGE="https://github.com/yifeikong/curl_cffi"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=net-misc/curl-impersonate-0.6.0"
BDEPEND="dev-python/cffi"

S="${WORKDIR}/curl_cffi-${PV}"

PATCHES=(
	"${FILESDIR}/no-download-0.6.0.patch"
	"${FILESDIR}/no-download_setup-0.6.1.patch"
)
