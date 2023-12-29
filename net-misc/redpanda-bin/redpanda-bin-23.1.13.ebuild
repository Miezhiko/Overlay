# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="streaming data platform for developers"
HOMEPAGE="https://github.com/redpanda-data"

SRC_URI="https://github.com/redpanda-data/redpanda/releases/download/v23.1.13/rpk-linux-amd64.zip"

RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="net-misc/lksctp-tools"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}"

src_install() {
	dobin rpk
}
