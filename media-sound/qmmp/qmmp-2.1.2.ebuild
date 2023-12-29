# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Qt6-based audio player with winamp/xmms skins support"
HOMEPAGE="http://qmmp.ylsoftware.com"

SRC_URI="http://qmmp.ylsoftware.com/files/${P}.tar.bz2
		mirror://sourceforge/${PN}-dev/files/${P}.tar.bz2"
KEYWORDS="amd64 x86"

LICENSE="GPL-2"
SLOT="0"
# KEYWORDS further up
IUSE="aac +alsa analyzer archive bs2b cdda cover crossfade cue curl +dbus enca
ffmpeg flac game gnome jack ladspa lyrics +mad midi mms mplayer musepack
notifier opus oss pipewire projectm pulseaudio qsui qtmedia scrobbler shout sid
sndfile soxr stereo tray udisks +vorbis wavpack xmp"

REQUIRED_USE="
	gnome? ( dbus )
	shout? ( soxr vorbis )
	udisks? ( dbus )
"

# minimum Qt version required
QT_PV="6.4.0:6"

RDEPEND="
	>=dev-qt/qtbase-${QT_PV}[concurrent,gui,network,sql,widgets]
	>=dev-qt/qtdeclarative-${QT_PV}
	media-libs/taglib
	x11-libs/libX11
	aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	archive? ( app-arch/libarchive )
	bs2b? ( media-libs/libbs2b )
	cdda? (
		dev-libs/libcdio:=
		dev-libs/libcdio-paranoia
	)
	curl? ( net-misc/curl )
	enca? ( app-i18n/enca )
	ffmpeg? ( media-video/ffmpeg:= )
	flac? ( media-libs/flac:= )
	game? ( media-libs/game-music-emu )
	jack? (
		media-libs/libsamplerate
		virtual/jack
	)
	ladspa? ( media-plugins/cmt-plugins )
	mad? (
		media-libs/libmad:=
		media-sound/mpg123:=
	)
	midi? ( media-sound/wildmidi )
	mms? ( media-libs/libmms )
	mplayer? ( media-video/mplayer )
	musepack? ( >=media-sound/musepack-tools-444 )
	opus? ( media-libs/opusfile )
	pipewire? ( media-video/pipewire )
	projectm? (
		media-libs/libprojectm:=
	)
	pulseaudio? ( >=media-sound/pulseaudio-0.9.9 )
	scrobbler? ( net-misc/curl )
	shout? ( media-libs/libshout )
	sid? ( >=media-libs/libsidplayfp-1.1.0 )
	sndfile? ( media-libs/libsndfile )
	soxr? ( media-libs/soxr )
	udisks? ( sys-fs/udisks:2 )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	wavpack? ( media-sound/wavpack )
	xmp? ( media-libs/libxmp )
"

DEPEND="${RDEPEND}"
BDEPEND=""

DOCS=( AUTHORS ChangeLog README )

src_prepare() {
	if has_version dev-libs/libcdio-paranoia ; then
		sed -i \
			-e 's:cdio/cdda.h:cdio/paranoia/cdda.h:' \
			src/plugins/Input/cdaudio/decoder_cdaudio.cpp || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUSE_AAC="$(usex aac)"
		-DUSE_ALSA="$(usex alsa)"
		-DUSE_ANALYZER="$(usex analyzer)"
		-DUSE_ARCHIVE="$(usex archive)"
		-DUSE_BS2B="$(usex bs2b)"
		-DUSE_CDA="$(usex cdda)"
		-DUSE_COVER="$(usex cover)"
		-DUSE_CROSSFADE="$(usex crossfade)"
		-DUSE_CUE="$(usex cue)"
		-DUSE_CURL="$(usex curl)"
		-DUSE_KDENOTIFY="$(usex dbus)"
		-DUSE_MPRIS="$(usex dbus)"
		-DUSE_ENCA="$(usex enca)"
		-DUSE_FFMPEG="$(usex ffmpeg)"
		-DUSE_FILEWRITER="$(usex vorbis)"
		-DUSE_FLAC="$(usex flac)"
		-DUSE_GME="$(usex game)"
		-DUSE_GNOMEHOTKEY="$(usex gnome)"
		-DUSE_JACK="$(usex jack)"
		-DUSE_LADSPA="$(usex ladspa)"
		-DUSE_LYRICS="$(usex lyrics)"
		-DUSE_MAD="$(usex mad)"
		-DUSE_MIDI="$(usex midi)"
		-DUSE_MMS="$(usex mms)"
		-DUSE_MPLAYER="$(usex mplayer)"
		-DUSE_MPC="$(usex musepack)"
		-DUSE_NOTIFIER="$(usex notifier)"
		-DUSE_OPUS="$(usex opus)"
		-DUSE_OSS="$(usex oss)"
		-DUSE_PIPEWIRE="$(usex pipewire)"
		-DUSE_PROJECTM="$(usex projectm)"
		-DUSE_PULSE="$(usex pulseaudio)"
		-DUSE_QSUI="$(usex qsui)"
		-DUSE_QTMULTIMEDIA="$(usex qtmedia)"
		-DUSE_SCROBBLER="$(usex scrobbler)"
		-DUSE_SHOUT="$(usex shout)"
		-DUSE_SID="$(usex sid)"
		-DUSE_SNDFILE="$(usex sndfile)"
		-DUSE_SOXR="$(usex soxr)"
		-DUSE_STEREO="$(usex stereo)"
		-DUSE_STATICON="$(usex tray)"
		-DUSE_UDISKS="$(usex udisks)"
		-DUSE_VORBIS="$(usex vorbis)"
		-DUSE_WAVPACK="$(usex wavpack)"
		-DUSE_XMP="$(usex xmp)"
	)

	cmake_src_configure
}
