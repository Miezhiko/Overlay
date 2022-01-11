# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="An implementation of the Double Ratchet cryptographic ratchet in C++"
HOMEPAGE="https://git.matrix.org/git/olm/about/"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.matrix.org/matrix-org/${PN}.git"
else
	SRC_URI="https://gitlab.matrix.org/matrix-org/${PN}/-/archive/${PV}/${P}.tar.bz2"
fi

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0/$(ver_cut 1)"
IUSE="debug"
