# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A complete implementation of the MS-NLMP documents as a GSSAPI mechanism"
HOMEPAGE="https://github.com/gssapi/gss-ntlmssp"
SRC_URI="https://github.com/gssapi/gss-ntlmssp/archive/refs/tags/v${PV}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
   default
   eautoreconf
}

