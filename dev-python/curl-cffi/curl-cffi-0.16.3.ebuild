# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..15} pypy3 )
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

# scripts/build.py was rewritten upstream (somewhere after the 0.7 series
# this ebuild used to carry no-download-*.patch for) to read these two env
# vars directly, in place of its own download-a-prebuilt-release step --
# confirmed against the current scripts/build.py source. Point it at
# net-misc/curl-impersonate's own install location instead of patching out
# the download, which is both simpler and no longer version-pinned to a
# specific upstream build.py revision.
src_compile() {
	local -x IMPERSONATE_BUILD_DIR="${EPREFIX}/usr/$(get_libdir)"
	local -x IMPERSONATE_LINK_TYPE="dynamic"
	distutils-r1_src_compile
}
