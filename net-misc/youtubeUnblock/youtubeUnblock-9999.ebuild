# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit git-r3 toolchain-funcs

DESCRIPTION="Bypasses Googlevideo detection systems that relies on SNI"
EGIT_REPO_URI="https://github.com/Waujito/youtubeUnblock.git"
EGIT_BRANCH="main"
HOMEPAGE="https://github.com/Waujito/youtubeUnblock"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-firewall/iptables"
BDEPEND="
	net-libs/libmnl
	net-libs/libnetfilter_queue
	net-libs/libnfnetlink
"
RDEPEND="${DEPEND}"

src_compile() {
	emake USE_SYS_LIBS=yes CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LD="${LD}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake USE_SYS_LIBS=yes DESTDIR="${D}" PREFIX="/usr" install
	newinitd "${FILESDIR}"/youtubeUnblock.initd youtubeUnblock
}
