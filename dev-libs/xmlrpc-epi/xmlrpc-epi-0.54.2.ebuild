# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools eutils flag-o-matic

DESCRIPTION="An implementation of the xmlrpc protocol in C"
HOMEPAGE="http://xmlrpc-epi.sourceforge.net/"
SRC_URI="https://iweb.dl.sourceforge.net/project/xmlrpc-epi/xmlrpc-epi-base/${PV}/xmlrpc-epi-${PV}.tar.bz2"
RESTRICT="mirror"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-devel/gettext"

S="${WORKDIR}/${P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/xmlrpc-epi-0.51-secondlife.patch
	eautoreconf
}

src_compile() {
	econf --includedir="/usr/include/xmlrpc-epi" --program-prefix="xmlrpc-epi-"
	emake || die "Make failed!"
}


src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}
