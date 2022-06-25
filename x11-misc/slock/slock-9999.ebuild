# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fcaps savedconfig toolchain-funcs git-r3

DESCRIPTION="simple X display locker"
HOMEPAGE="https://tools.suckless.org/slock"

EGIT_REPO_URI="https://github.com/Miezhiko/slock.git"
EGIT_BRANCH="master"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~hppa ppc64 x86"

RDEPEND="
	virtual/libcrypt:=
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

src_prepare() {
	default
	restore_config config.h
	tc-export CC
}

src_compile() {
	emake slock
}

src_install() {
	dobin slock
	save_config config.h
}

pkg_postinst() {
	# cap_dac_read_search used to be enough for shadow access
	# but now slock wants to write to /proc/self/oom_score_adj
	# and for that it needs:
	fcaps \
		cap_dac_override,cap_setgid,cap_setuid,cap_sys_resource \
		/usr/bin/slock

	savedconfig_pkg_postinst
}
