# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit git-r3

DESCRIPTION="zapret"
EGIT_REPO_URI="https://github.com/bol-van/zapret.git"
HOMEPAGE="https://github.com/bol-van/zapret"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/libnetfilter_queue
	net-firewall/ipset
	net-firewall/iptables"
RDEPEND="${DEPEND}"

src_install() {
	dodir opt/ || die
	dodir opt/"${PN}" || die
	cp -r "${S}"/* "${ED}"/opt/"${PN}"/ || die
}
