# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo git-r3 meson xdg

DESCRIPTION="GStreamer plugins written in Rust"
HOMEPAGE="https://gstreamer.freedesktop.org/"
EGIT_REPO_URI="https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs.git"
EGIT_COMMIT="0.15.4"

LICENSE="|| ( LGPL-2.1+ MIT Apache-2.0 MPL-2.0 )"
SLOT="1.0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	media-libs/dav1d
	gui-libs/gtk:4
	dev-libs/libsodium
	media-libs/libwebp
	!media-plugins/gst-plugin-gtk4
"
RDEPEND="${DEPEND}"

DISABLED_PLUGINS=(
	whisper
	validate
)

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack

	local builddir="${WORKDIR}/build"
	mkdir -p "${builddir}"

	# aws-lc-sys (a C/assembly -sys crate pulled in transitively, e.g. by
	# the aws/elevenlabs/deepgram plugins' TLS stack) compiles its C
	# sources with CFLAGS as usual. With -flto=thin in CFLAGS the
	# resulting objects are LLVM bitcode, which the plain (non-LTO-aware)
	# `ld.bfd` invocation cargo/rustc uses to link the final .so can't
	# read: "error adding symbols: file format not recognized". Rust's
	# own codegen isn't affected (rustc drives its own LTO separately via
	# -C lto), so just drop -flto* from the C/C++ flags feeding cc-rs.
	filter-flags '-flto*'

	tc-export CC CXX AR NM OBJCOPY PKG_CONFIG
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export LD=$(tc-getLD)
	export AR=$(tc-getAR)
	export NM=$(tc-getNM)
	export PKG_CONFIG=$(tc-getPKG_CONFIG)

	local emesonargs=(
		--libdir="$(get_libdir)"
		--prefix="${EPREFIX}/usr"
		--sysconfdir="${EPREFIX}/etc"
		--localstatedir="${EPREFIX}/var/lib"
		-Dcsound=disabled
		-Ddoc=disabled
		-Dsodium-source=system
		-Dwhisper=disabled # 0.15.1 bug
		$(for plugin in "${DISABLED_PLUGINS[@]}"; do echo "-D${plugin}=disabled"; done)
	)

	pushd "${builddir}" || die
	meson setup "${emesonargs[@]}" "${S}" || die "meson setup failed"

	ninja -j$(makeopts_jobs) || die "ninja build failed"

	DESTDIR="${WORKDIR}/fake-root" ninja install || die "ninja install failed"
	popd
}

src_configure() { :; }
src_compile() { :; }
src_test() { :; }

src_install() {
	cp -r "${WORKDIR}/fake-root"/. "${D}" || die
	einstalldocs
}
