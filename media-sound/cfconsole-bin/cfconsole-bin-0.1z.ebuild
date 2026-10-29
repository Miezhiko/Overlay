# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

DESCRIPTION="Clownfish Voice Changer Console - A real-time voice changer application"
HOMEPAGE="https://clownfish-translator.com/voicechanger/"
MY_PV="v${PV}"
SRC_URI="https://clownfish-translator.com/voicechanger/download/ClownfishConsole/linux64/ClownfishConsole(${MY_PV}).zip -> ${P}.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist mirror strip"

QA_PREBUILT="/usr/bin/cfconsole"

RDEPEND="
	dev-libs/glib:2
	media-libs/alsa-lib
	sys-libs/zlib
"

S="${WORKDIR}"

src_unpack() {
	unpacker_src_unpack
}

src_install() {
	# Install the binary
	exeinto /usr/bin
	newbin ClownfishConsole cfconsole

	# Install desktop file
	cat > "${T}/cfconsole.desktop" <<- EOF || die
		[Desktop Entry]
		Type=Application
		Name=Clownfish Voice Changer Console
		Comment=A real-time voice changer application
		Icon=audio-input-microphone
		Categories=AudioVideo;Audio;
		Exec=cfconsole
		TryExec=cfconsole
	EOF
	domenu "${T}/cfconsole.desktop"
}

pkg_postinst() {
	xdg_pkg_postinst
	einfo "Clownfish Voice Changer Console has been installed."
	einfo "You can run it with 'cfconsole' or find it in your application menu."
}

pkg_postrm() {
	xdg_pkg_postrm
}