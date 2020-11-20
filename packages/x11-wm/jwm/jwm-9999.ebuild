EAPI=7
inherit eutils autotools git-r3

DESCRIPTION="JWM"
EGIT_REPO_URI="https://github.com/Qeenon/jwm.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-libs/expat
         x11-libs/libXau
         x11-libs/libXdmcp
         x11-libs/libXext
         x11-libs/libXmu
         x11-libs/libXrender
         dev-libs/fribidi
         x11-libs/cairo
         gnome-base/librsvg
         virtual/libiconv
         virtual/jpeg
         sys-devel/gettext
         virtual/libintl
         media-libs/libpng
         x11-libs/libXft
         x11-libs/libXinerama
         x11-libs/libXpm"
DEPEND="${RDEPEND} x11-base/xorg-proto"

src_configure() {
  ./autogen.sh || die "autostuff failed"
  econf \
    --enable-icons \
    --enable-fribidi \
    --enable-cairo \
    --disable-debug \
    --enable-jpeg \
    --enable-nls \
    --enable-png \
    --enable-rsvg \
    --enable-xft \
    --enable-xinerama \
    --enable-xpm \
    --with-libiconv-prefix /usr \
    --with-libintl-prefix /usr \
    --enable-shape \
    --enable-xrender \
    --disable-rpath
}

src_install() {
  dodir /etc
  dodir /usr/bin
  dodir /usr/share/man
  default
  make_wrapper "${PN}" "/usr/bin/${PN}" "" "" "/etc/X11/Sessions"
  insinto "/usr/share/xsessions"
  doins "${FILESDIR}"/jwm.desktop
}
