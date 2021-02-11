# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CSV="csv${PV}"

inherit autotools multilib wrapper

DESCRIPTION="Open-source Chez Scheme implementation from Cisco"
HOMEPAGE="https://cisco.github.io/ChezScheme/"
SRC_URI="https://github.com/cisco/ChezScheme/releases/download/v${PV}/${CSV}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror test"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

PATCHES=(
	"${FILESDIR}/chezscheme-tinfo.patch"
)

S="${WORKDIR}/${CSV}"

src_configure() {
	local myconf=(
		--64
		--threads
		--installbin="/usr/$(get_libdir)/${CSV}"
		--installlib="/usr/$(get_libdir)"
		--installman="/usr/share/man"
		--installprefix="/usr"
		--temproot="${D}"
	)
	sh ./configure "${myconf[@]}"
}

src_install() {
	default

	local chez_dir="${EPREFIX}/usr/$(get_libdir)/${CSV}"
	make_wrapper "${PN}" "${chez_dir}/scheme"
	make_wrapper "chez" "${chez_dir}/scheme"
	make_wrapper "petite" "${chez_dir}/petite"
	make_wrapper "scheme-script" "${chez_dir}/scheme-script"
}
