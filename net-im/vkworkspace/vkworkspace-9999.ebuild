# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg

MY_PN="vkworkspace"

DESCRIPTION="VK WorkSpace SuperApp — unified client for VK WorkSpace services"
HOMEPAGE="https://workspace.vk.ru/download/"
SRC_URI="https://hb.bizmrg.com/vkteams-www/linux/x64/vkworkspace.deb"

S="${WORKDIR}"

LICENSE="vk-workspace"   # proprietary
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""

RESTRICT="mirror strip"

RDEPEND="
	app-accessibility/at-spi2-core
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/pango
"

QA_PREBUILT="*"

src_unpack() {
	unpacker "${DISTDIR}/${MY_PN}.deb"
}

src_install() {
	insinto /
	doins -r usr/

	fperms 0755 /usr/local/vkworkspace/vkworkspace

	local wrapper="${T}/vkworkspace"
	local idir="/usr/local/vkworkspace"

  # FORCING TO XCB BECAUSE THERE IS PURE WAYLAND PLUGIN MISSING!
	printf '#!/bin/sh\n' > "${wrapper}"
	printf 'INSTALL_DIR="%s"\n' "${idir}" >> "${wrapper}"
	printf 'export QT_QPA_PLATFORM_PLUGIN_PATH="/usr/local/vkworkspace/plugins/platforms"\n' >> "${wrapper}"
	printf 'export QT_PLUGIN_PATH="/usr/local/vkworkspace/plugins"\n' >> "${wrapper}"
	printf 'export LD_LIBRARY_PATH="/usr/local/vkworkspace/lib:${LD_LIBRARY_PATH}"\n' >> "${wrapper}"
	printf 'export QT_QPA_PLATFORM="xcb"\n' >> "${wrapper}"
	printf 'exec "${INSTALL_DIR}/vkworkspace" "$@"\n' >> "${wrapper}"

	dobin "${wrapper}"

	if [[ -d usr/share/applications ]]; then
		insinto /usr/share/applications
		doins usr/share/applications/*.desktop
	fi

	if [[ -d usr/share/icons ]]; then
		insinto /usr/share/icons
		doins -r usr/share/icons/.
	fi
	
	sed -i 's|Exec=/usr/local/vkworkspace/vkworkspace|Exec=/usr/bin/vkworkspace|' \
		"${ED}/usr/share/applications/vkworkspace.desktop"
}

pkg_postinst() {
	xdg_pkg_postinst
}
