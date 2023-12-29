# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7


inherit git-r3

EGIT_REPO_URI="https://git.alchemyviewer.org/alchemy/thirdparty/3p-glh_linear.git"

DESCRIPTION="glh - is a platform-indepenedent C++ OpenGL helper library"
HOMEPAGE="https://git.alchemyviewer.org/alchemy/thirdparty/3p-glh_linear"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	# Install headers
	cd "${S}/glh_linear"
	insinto /usr/include/GL
	doins include/GL/*.h
	insinto /usr/include/glh
	doins include/glh/*.h
	dodoc LICENSES/glh-linear.txt
}
