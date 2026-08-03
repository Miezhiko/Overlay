# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Node.js eselect module"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
S=${WORKDIR}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

# The blocker mirrors the one every slotted net-libs/nodejs carries, and it has
# to live here too: this package takes ownership of /etc/env.d/50npm, which an
# already-merged unslotted nodejs still records in its CONTENTS.  Portage merges
# a dependency before its dependant, so without a strong blocker this package
# would be merged while nodejs:0 is still installed and FEATURES="protect-owned"
# would abort on that one file.  Strong (!!) rather than weak, so the unslotted
# package is unmerged before this one is merged rather than alongside it.
# Precedent: app-eselect/eselect-lua blocks dev-lang/lua:0 for the same reason.
RDEPEND="
	app-admin/eselect
	!!net-libs/nodejs:0
"

src_install() {
	insinto /usr/share/eselect/modules/
	newins "${FILESDIR}"/nodejs.eselect-${PV} nodejs.eselect

	# The shared npm configuration lives here rather than in net-libs/nodejs:
	# neither path is slot-specific, so two installed slots would own the same
	# file, and FEATURES="protect-owned" turns that collision into a merge
	# failure.  Owning them from this single-instance package keeps
	# NPM_CONFIG_GLOBALCONFIG pointing at one shared file for every slot.
	# Only the directory is owned; npmrc itself is created by the user.
	keepdir /etc/npm
	echo "NPM_CONFIG_GLOBALCONFIG=${EPREFIX}/etc/npm/npmrc" > "${T}"/50npm || die
	doenvd "${T}"/50npm
}
