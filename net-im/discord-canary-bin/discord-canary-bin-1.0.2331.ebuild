# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-bin/}"
MY_BIN="D${MY_PN/d/}"
MY_BIN="${MY_BIN/-canary/}Canary"
MY_PV="${PV/-r*/}"

CHROMIUM_LANGS="
	af am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk ur vi zh-CN zh-TW
"

inherit chromium-2 desktop linux-info optfeature unpacker xdg

DESCRIPTION="All-in-one voice and text chat"
HOMEPAGE="https://discord.com/"

# Upstream only ships a thin updater_bootstrap in the .deb nowadays (same
# switch discord/discord did a while ago). Pull the actual app the same way
# the main-tree net-im/discord ebuild does: the legacy brotli-compressed
# "full.distro" blobs the autoupdater itself would fetch, for both the base
# app and the Node modules it needs at first launch.
SRC_URI="
	https://canary.dl2.discordapp.net/distro/app/canary/linux/x64/${MY_PV}/full.distro -> ${P}.distro
	https://canary.dl2.discordapp.net/distro/app/canary/linux/x64/${MY_PV}/discord_desktop_core/1/full.distro
		-> ${P}-discord_desktop_core.distro
	https://canary.dl2.discordapp.net/distro/app/canary/linux/x64/${MY_PV}/discord_erlpack/1/full.distro
		-> ${P}-discord_erlpack.distro
	https://canary.dl2.discordapp.net/distro/app/canary/linux/x64/${MY_PV}/discord_spellcheck/1/full.distro
		-> ${P}-discord_spellcheck.distro
	https://canary.dl2.discordapp.net/distro/app/canary/linux/x64/${MY_PV}/discord_utils/1/full.distro
		-> ${P}-discord_utils.distro
	https://canary.dl2.discordapp.net/distro/app/canary/linux/x64/${MY_PV}/discord_voice/1/full.distro
		-> ${P}-discord_voice.distro
	https://canary.dl2.discordapp.net/distro/app/canary/linux/x64/${MY_PV}/discord_zstd/1/full.distro
		-> ${P}-discord_zstd.distro
"
S="${WORKDIR}/${MY_BIN}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"

IUSE="appindicator +seccomp wayland"
RESTRICT="bindist mirror strip test"
RDEPEND="
	app-accessibility/at-spi2-core:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	dev-libs/wayland
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/mesa[gbm(+)]
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libxshmfence
	x11-libs/pango
	appindicator? ( dev-libs/libayatana-appindicator )
"

DESTDIR="/opt/${MY_PN}"

QA_PREBUILT="*"

CONFIG_CHECK="~USER_NS"

repackage_node_modules() {
	brotli -d "${DISTDIR}/${P}"-$1.distro -o "${T}"/$1.tar 2>/dev/null || die
	unpack "${T}"/$1.tar || die
	pushd "${WORKDIR}"/files 2>/dev/null || die
	zip -rq "${WORKDIR}"/$1.zip . || die
	popd 2>/dev/null || die
	mv $1.zip "${S}"/resources/bootstrap/ || die
	rm -r "${WORKDIR}"/files || die
}

src_unpack() {
	# See the matching comment in net-im/discord: upstream's .deb is now only
	# an autoupdater stub, so fetch the real app and its Node modules from the
	# same brotli-compressed distro blobs the autoupdater would, and stage the
	# modules as bootstrap zips so the app installs them on first launch.
	brotli -d "${DISTDIR}/${P}".distro -o "${T}/${P}.tar" 2>/dev/null || die
	unpack "${T}/${P}.tar"
	mv "${WORKDIR}"/files "${S}" || die
	rm "${T}/${P}.tar" || die
	repackage_node_modules "discord_desktop_core"
	repackage_node_modules "discord_erlpack"
	repackage_node_modules "discord_spellcheck"
	repackage_node_modules "discord_utils"
	repackage_node_modules "discord_voice"
	repackage_node_modules "discord_zstd"
}

src_configure() {
	default
	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	default

	pushd "locales/" >/dev/null || die "location change for language cleanup failed"
	chromium_remove_language_paks
	popd >/dev/null || die "location reset for language cleanup failed"

	sed --expression "s:@@DESTDIR@@:${DESTDIR}:" \
		"${FILESDIR}/launcher.sh" > "${T}/launcher.sh" || die "updating of exec location in launcher failed"

	if use seccomp; then
		sed --in-place --expression '/^EBUILD_SECCOMP=/s/false/true/' \
			"${T}/launcher.sh" || die "sed failed for seccomp"
	fi

	if use wayland; then
		sed --in-place --expression '/^EBUILD_WAYLAND=/s/false/true/' \
			"${T}/launcher.sh" || die "sed failed for wayland"
	fi

	cp "${FILESDIR}/manifest.json" resources/bootstrap/manifest.json || die "Failed copying manifest.json"
}

src_install() {
	newicon -s 256 discord.png "${MY_PN}.png"

	make_desktop_entry "${EPREFIX}/usr/bin/${MY_PN}" "Discord Canary" "${MY_PN}" \
		"Network;InstantMessaging;" \
		"StartupWMClass=discord-canary" \
		"Path=${EPREFIX}/usr/bin"

	exeinto "${DESTDIR}"

	doexe "${MY_BIN}" chrome-sandbox libEGL.so libffmpeg.so libGLESv2.so libvk_swiftshader.so

	insinto "${DESTDIR}"
	doins chrome_100_percent.pak chrome_200_percent.pak icudtl.dat resources.pak \
		snapshot_blob.bin v8_context_snapshot.bin libvulkan.so.1 updater.node \
		vk_swiftshader_icd.json
	insopts -m0755
	doins -r locales resources

	# Chrome-sandbox requires the setuid bit to be specifically set.
	# see https://github.com/electron/electron/issues/17972
	fowners root "${DESTDIR}/chrome-sandbox"
	fperms 4711 "${DESTDIR}/chrome-sandbox"

	[[ -x chrome_crashpad_handler ]] && doins chrome_crashpad_handler

	exeinto "/usr/bin"
	newexe "${T}/launcher.sh" "${MY_PN}" || die "failing to install launcher"

	if use appindicator; then
		dosym ../../usr/lib64/libayatana-appindicator3.so "${DESTDIR}/libappindicator3.so"
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature_header "Install the following packages for additional support:"
	optfeature "sound support" \
		media-sound/pulseaudio media-sound/apulse[sdk] media-video/pipewire
	optfeature "emoji support" media-fonts/noto-emoji
}
