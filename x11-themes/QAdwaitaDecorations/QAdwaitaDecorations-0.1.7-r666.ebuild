# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

DESCRIPTION="Qt5 decoration plugin implementing Adwaita-like client-side decorations"
HOMEPAGE="https://github.com/FedoraQt/QAdwaitaDecorations"
SRC_URI="https://github.com/FedoraQt/${PN}/archive/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	dev-qt/qtcore:5
"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUSE_QT6=false
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	insinto /etc/profile.d
	doins "${FILESDIR}/90-${PN}.sh"
}
