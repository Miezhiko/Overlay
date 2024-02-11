# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A Client that groks URLs"
HOMEPAGE="https://curl.se/"
SRC_URI="https://github.com/lwthiker/curl-impersonate/releases/download/v${PV}/libcurl-impersonate-v${PV}.x86_64-linux-gnu.tar.gz -> ${P}-bin.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT=""
IUSE+=""

RDEPEND=""
DEPEND="${RDEPEND}"
BDEPEND=""

S="${WORKDIR}"

src_prepare() {
	default
}

src_configure() {
  :;
}

src_compile() {
	:;
}

src_install() {
	 insinto /usr/lib64
	 doins libcurl-impersonate-chrome.la
	 doins libcurl-impersonate-chrome.so
	 doins libcurl-impersonate-chrome.so.4
	 doins libcurl-impersonate-chrome.so.4.8.0
	 doins libcurl-impersonate-ff.a
	 doins libcurl-impersonate-ff.la
	 doins libcurl-impersonate-ff.so
	 doins libcurl-impersonate-ff.so.4
	 doins libcurl-impersonate-ff.so.4.8.0
}

