# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..13} )

RUST_MIN_VER="1.85.1"
RUST_MULTILIB=1
VALA_MIN_API_VERSION="0.56"

inherit cargo gnome2 multilib-minimal python-any-r1 rust-toolchain vala meson git-r3

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library"
HOMEPAGE="https://wiki.gnome.org/Projects/LibRsvg https://gitlab.gnome.org/GNOME/librsvg"
SRC_URI+=" ${CARGO_CRATE_URIS}"

LICENSE="LGPL-2.1+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD ISC MIT MPL-2.0
	Unicode-DFS-2016
"

SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

IUSE="gtk-doc +introspection +vala"
REQUIRED_USE="
	gtk-doc? ( introspection )
	vala? ( introspection )
"

RDEPEND="
	>=x11-libs/cairo-1.17.0[glib,svg(+),${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.9:2[${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.20:2[introspection?,${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.50.0:2[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-2.0.0:=[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4:2[${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.50.0[${MULTILIB_USEDEP}]

	introspection? ( >=dev-libs/gobject-introspection-0.10.8:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	x11-libs/gdk-pixbuf
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/docutils[${PYTHON_USEDEP}]')
	gtk-doc? ( dev-util/gi-docgen )
	virtual/pkgconfig
	vala? ( >=dev-lang/vala-0.56.18 )

	dev-libs/gobject-introspection-common
	dev-libs/vala-common
	dev-util/cargo-c
"
# dev-libs/gobject-introspection-common, dev-libs/vala-common needed by eautoreconf

QA_FLAGS_IGNORED="
	usr/bin/rsvg-convert
	usr/lib.*/librsvg.*
"

my_live_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	[[ "${EBUILD_PHASE}" == unpack ]] || die "${FUNCNAME} only allowed in src_unpack"

	mkdir -p "${S}" || die
	mkdir -p "${ECARGO_VENDOR}" || die
	mkdir -p "${ECARGO_HOME}" || die

	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	: "${ECARGO_REGISTRY_DIR:=${distdir}/cargo-registry}"

	local offline="${ECARGO_OFFLINE:-${EVCS_OFFLINE}}"

	if [[ ! -d ${ECARGO_REGISTRY_DIR} && ! ${offline} ]]; then
		(
			addwrite "${ECARGO_REGISTRY_DIR}"
			mkdir -p "${ECARGO_REGISTRY_DIR}"
		) || die "Unable to create ${ECARGO_REGISTRY_DIR}"
	fi

	if [[ ${offline} ]]; then
		local subdir
		for subdir in cache index src; do
			if [[ ! -d ${ECARGO_REGISTRY_DIR}/registry/${subdir} ]]; then
				eerror "Networking activity has been disabled via ECARGO_OFFLINE or EVCS_OFFLINE"
				eerror "However, no valid cargo registry available at ${ECARGO_REGISTRY_DIR}"
				die "Unable to proceed with ECARGO_OFFLINE/EVCS_OFFLINE."
			fi
		done
	fi

	if [[ ${EVCS_UMASK} ]]; then
		local saved_umask=$(umask)
		umask "${EVCS_UMASK}" || die "Bad options to umask: ${EVCS_UMASK}"
	fi

	pushd "${S}" > /dev/null || die

	# Respect user settings before cargo_gen_config is called.
	if [[ ! ${CARGO_TERM_COLOR} ]]; then
		[[ "${NOCOLOR}" = true || "${NOCOLOR}" = yes ]] && export CARGO_TERM_COLOR=never
		local unset_color=true
	fi
	if [[ ! ${CARGO_TERM_VERBOSE} ]]; then
		export CARGO_TERM_VERBOSE=true
		local unset_verbose=true
	fi

	# Let cargo fetch to system-wide location.
	# It will keep directory organized by itself.
	addwrite "${ECARGO_REGISTRY_DIR}"
	export CARGO_HOME="${ECARGO_REGISTRY_DIR}"

	# Absence of quotes around offline arg is intentional, as cargo bails out if it encounters ''
	einfo "cargo fetch ${offline:+--offline}"
	cargo fetch ${offline:+--offline} || die #nowarn

	# Let cargo copy all required crates to "${WORKDIR}" for offline use in later phases.
	einfo "cargo vendor ${offline:+--offline} ${ECARGO_VENDOR}"
	cargo vendor ${offline:+--offline} "${ECARGO_VENDOR}" || die #nowarn

	# Users may have git checkouts made by cargo.
	# While cargo vendors the sources, it still needs git checkout to be present.
	# Copying full dir is overkill, so just symlink it (guard w/ -L to keep idempotent).
	if [[ -d ${ECARGO_REGISTRY_DIR}/git && ! -L "${ECARGO_HOME}/git" ]]; then
		ln -sv "${ECARGO_REGISTRY_DIR}/git" "${ECARGO_HOME}/git" || die
	fi

	popd > /dev/null || die

	# Restore settings if needed.
	[[ ${unset_color} ]] && unset CARGO_TERM_COLOR
	[[ ${unset_verbose} ]] && unset CARGO_TERM_VERBOSE
	if [[ ${saved_umask} ]]; then
		umask "${saved_umask}" || die
	fi

	# After following calls, cargo will no longer use ${ECARGO_REGISTRY_DIR} as CARGO_HOME
	# It will be forced into offline mode to prevent network access.
	# But since we already vendored crates and symlinked git, it has all it needs to build.
	unset CARGO_HOME
	cargo_gen_config
}

pkg_setup() {
	rust_pkg_setup
	python-any-r1_pkg_setup
}

src_unpack() {
	default
	my_live_src_unpack
}

src_prepare() {
	use vala && vala_setup
	gnome2_src_prepare
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc docs)
		$(meson_feature introspection)
		$(meson_feature vala)
		-Dpixbuf-loader=true
	)

	if ! multilib_is_native_abi; then
		myconf+=(
			-Dtriplet="$(rust_abi)"
		)
	fi
	
	meson_src_configure

	if multilib_is_native_abi; then
		ln -s "${S}"/doc/html doc/html || die
	fi
}


multilib_src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc docs)
		$(meson_native_use_feature introspection)
		$(meson_native_use_feature vala)
		-Dpixbuf=enabled
		-Dpixbuf-loader=enabled
	)
	
	if ! multilib_is_native_abi; then
		myconf+=(
			-Dtriplet="$(rust_abi)"
		)
	fi
	
	meson_src_configure
}

multilib_src_install_all() {
	find "${ED}" -name '*.la' -delete || die

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/Rsvg-2.0 "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}

pkg_postinst() {
	multilib_foreach_abi gnome2_pkg_postinst
}

pkg_postrm() {
	multilib_foreach_abi gnome2_pkg_postrm
}

