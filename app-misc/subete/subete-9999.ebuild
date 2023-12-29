# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit git-r3

DESCRIPTION="subete"
EGIT_REPO_URI="https://github.com/Miezhiko/subete.git"
HOMEPAGE="https://github.com/Miezhiko/subete"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/sqlite:*"
RDEPEND="${DEPEND}"

