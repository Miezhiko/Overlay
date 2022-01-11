# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo git-r3

EGIT_REPO_URI="https://github.com/Spotifyd/spotifyd.git"
DESCRIPTION="A Spotify daemon"
HOMEPAGE="https://github.com/Spotifyd/spotifyd"

LICENSE="GPL-3"
RESTRICT="mirror"
SLOT="0"

IUSE="alsa dbus portaudio pulseaudio rodio"
REQUIRED_USE="|| ( alsa portaudio pulseaudio rodio )"

KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-lang/rust-1.50.0
	alsa? ( media-libs/alsa-lib )
	dbus? ( sys-apps/dbus )
	dev-libs/openssl:0=
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )"
RDEPEND="${DEPEND}"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_configure() {
	myfeatures=(
		$(usex alsa alsa_backend "")
		$(usex dbus "dbus_keyring dbus_mpris" "")
		$(usex portaudio portaudio_backend "")
		$(usex pulseaudio pulseaudio_backend "")
		$(usex rodio rodio_backend "")
	)
}

src_compile() {
	cargo_src_compile ${myfeatures:+--features "${myfeatures[*]}"} --no-default-features
}

src_install() {
	cargo_src_install ${myfeatures:+--features "${myfeatures[*]}"} --no-default-features

	keepdir /etc/xdg/spotifyd
}
