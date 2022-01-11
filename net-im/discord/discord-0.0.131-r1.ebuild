# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="All-in-one voice and text chat"

HOMEPAGE="https://discordapp.com/"

SRC_URI="https://dl-canary.discordapp.net/apps/linux/${PV}/discord-canary-${PV}.tar.gz"
RESTRICT="mirror"
KEYWORDS="~amd64"

SLOT="0"

# not really but something proprietary
LICENSE="google-chrome"

RDEPEND="|| ( <sys-libs/glibc-2.34 >=sys-libs/glibc-2.34[-clone3(+)] )"
DEPEND="${RDEPEND}
	sys-libs/libcxx
	dev-libs/expat
	dev-libs/nss
	media-gfx/graphite2
	media-libs/alsa-lib
	media-libs/libpng
	net-print/cups
	net-libs/gnutls
	sys-libs/zlib
	x11-libs/gtk+
	x11-libs/libnotify
	x11-libs/libxcb
	x11-libs/libXtst
	media-libs/opus"

S=${WORKDIR}/DiscordCanary

src_install() {
	local destdir="/opt/${PN}"

	insinto $destdir
	doins -r locales resources
	doins \
		*.pak \
		*.png \
		*.dat \
		*.bin \
		*.so

	exeinto $destdir
	doexe DiscordCanary

	dosym $destdir/DiscordCanary /usr/bin/discord-canary

	make_desktop_entry discord-canary Discord \
		"/opt/discord/discord.png" \
		Network
}
