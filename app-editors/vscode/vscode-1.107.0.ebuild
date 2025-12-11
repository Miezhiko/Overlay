# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop pax-utils xdg optfeature

DESCRIPTION="Multiplatform Visual Studio Code from Microsoft"
HOMEPAGE="https://code.visualstudio.com"
SRC_URI="https://update.code.visualstudio.com/${PV}/linux-x64/stable -> ${P}-amd64.tar.gz"
S="${WORKDIR}"

RESTRICT="mirror strip bindist"

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
  /opt/vscode/chrome_crashpad_handler
	/opt/vscode/chrome-sandbox
	/opt/vscode/code
	/opt/vscode/libEGL.so
	/opt/vscode/libffmpeg.so
	/opt/vscode/libGLESv2.so
	/opt/vscode/libvk_swiftshader.so
	/opt/vscode/libvulkan.so*
	/opt/vscode/resources/app/extensions/*
	/opt/vscode/resources/app/node_modules.asar.unpacked/*
	/opt/vscode/swiftshader/libEGL.so
	/opt/vscode/swiftshader/libGLESv2.so
"

QA_PREBUILT="*"

src_unpack() {
	default
	mv "${S}"/VSCode-linux-* "${S}/vscode" || die
}

src_configure() {
	default
	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	default
	pushd "vscode/locales" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die
}

src_install() {
	cd vscode || die

	# Cleanup
	rm -r ./resources/app/ThirdPartyNotices.txt || die

	# Disable update server
	sed -e "/updateUrl/d" -i ./resources/app/product.json || die

	# Install
	pax-mark m code
	mkdir -p "${ED}/opt/${PN}" || die
	cp -r . "${ED}/opt/${PN}" || die
	fperms 4711 /opt/${PN}/chrome-sandbox

	dosym -r "/opt/${PN}/bin/code" "usr/bin/vscode"
	dosym -r "/opt/${PN}/bin/code" "usr/bin/code"

	local EXEC_EXTRA_FLAGS=()

	sed "s|@exec_extra_flags@|${EXEC_EXTRA_FLAGS[*]}|g" \
		"${FILESDIR}/code-url-handler.desktop" \
		> "${T}/code-url-handler.desktop" || die

	sed "s|@exec_extra_flags@|${EXEC_EXTRA_FLAGS[*]}|g" \
		"${FILESDIR}/code.desktop" \
		> "${T}/code.desktop" || die

	sed "s|@exec_extra_flags@|${EXEC_EXTRA_FLAGS[*]}|g" \
		"${FILESDIR}/code-open-in-new-window.desktop" \
		> "${T}/code-open-in-new-window.desktop" || die

	domenu "${T}/code.desktop"
	domenu "${T}/code-url-handler.desktop"
	domenu "${T}/code-open-in-new-window.desktop"
	newicon "resources/app/resources/linux/code.png" "vscode.png"
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "keyring support inside vscode" "gnome-base/gnome-keyring"
}
