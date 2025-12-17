# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Code editor from the creators of Atom"
HOMEPAGE="https://code.visualstudio.com"
SRC_URI="https://github.com/zed-industries/zed/releases/download/v${PV}/zed-linux-x86_64.tar.gz"
S="${WORKDIR}"

RESTRICT="mirror strip bindist"

# no idea, those are randome ones:
LICENSE="
	Apache-2.0
	BSD
	BSD-1
	BSD-2
	BSD-4
	CC-BY-4.0
	ISC
	LGPL-2.1+
	Microsoft-vscode
	MIT
	MPL-2.0
	openssl
	PYTHON
	TextMate-bundle
	Unlicense
	UoI-NCSA
	W3C
"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	app-accessibility/at-spi2-atk:2
	app-accessibility/at-spi2-core:2
	app-crypt/libsecret[crypt]
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libxkbfile
	x11-libs/libXrandr
	x11-libs/libxshmfence
	x11-libs/pango
"

QA_PREBUILT="
	/opt/zed-bin/*
"

src_install() {
	insinto "/opt/${PN}"
	doins -r *
	
	fperms +x /opt/${PN}/zed.app/bin/zed
	fperms +x /opt/${PN}/zed.app/libexec/zed-editor
	
	dosym "../../opt/${PN}/zed.app/bin/zed" "usr/bin/zed"
	
	domenu "${FILESDIR}/zed.desktop"
	newicon "zed.app/share/icons/hicolor/512x512/apps/zed.png" "zed.png"
}

pkg_postinst() {
	xdg_pkg_postinst
}
