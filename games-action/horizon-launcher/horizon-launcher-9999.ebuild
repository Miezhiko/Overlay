# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""

RUST_MIN_VER="1.95.0"

inherit cargo git-r3 xdg

DESCRIPTION="Desktop launcher for Horizon, a Rust reimplementation of Minecraft Java Edition"
HOMEPAGE="https://github.com/horizon-rust/horizon"

EGIT_REPO_URI="https://github.com/horizon-rust/horizon.git"
EGIT_BRANCH="main"
EGIT_CHECKOUT_DIR="${WORKDIR}/horizon-src"

S="${EGIT_CHECKOUT_DIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="X wayland"

REQUIRED_USE="|| ( X wayland )"

BDEPEND="
	dev-vcs/git
"

RDEPEND="
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/libxkbcommon
	X? (
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXi
		x11-libs/libXrandr
	)
	wayland? (
		dev-libs/wayland
	)
"

src_unpack() {
	git-r3_src_unpack

	[[ -f "${S}/Cargo.toml" ]] ||
		die "Repository workspace Cargo.toml not found"

	[[ -f "${S}/launcher/Cargo.toml" ]] ||
		die "Launcher Cargo.toml not found"

	mkdir -p "${ECARGO_HOME}" "${ECARGO_VENDOR}" ||
		die "Could not create Cargo directories"

	(
		cd "${S}" || die "Could not enter ${S}"
		export CARGO_HOME="${ECARGO_HOME}"

		einfo "Fetching launcher Cargo dependencies"
		"${CARGO}" fetch --manifest-path launcher/Cargo.toml ||
			die "Cargo dependency fetch failed"

		einfo "Vendoring launcher Cargo dependencies"
		"${CARGO}" vendor --manifest-path launcher/Cargo.toml "${ECARGO_VENDOR}" ||
			die "Cargo dependency vendoring failed"
	) || die "Cargo live unpack failed"

	cargo_gen_config
}

src_prepare() {
	default

	local manifest="${S}/launcher/Cargo.toml"

	[[ -f "${manifest}" ]] ||
		die "Launcher Cargo.toml not found: ${manifest}"

	# Let the USE flags control the platform features.
	sed -i \
		-e 's/features = \["wayland", "x11", "font-kit"\]/features = ["font-kit"]/' \
		"${manifest}" ||
		die "Could not adjust GPUI platform features"

	grep -Fq 'features = ["font-kit"]' "${manifest}" ||
		die "Expected GPUI platform feature declaration was not found"
}

src_configure() {
	local myfeatures=(
		$(usev X gpui_platform/x11)
		$(usev wayland gpui_platform/wayland)
	)

	cargo_src_configure --manifest-path launcher/Cargo.toml
}

src_compile() {
	local commit

	commit=$(git -C "${S}" rev-parse --short=7 HEAD) ||
		die "Could not determine short Git commit hash"

	[[ ${commit} =~ ^[[:xdigit:]]{7}$ ]] ||
		die "Invalid short Git commit hash: ${commit}"

	export HORIZON_MSA_CLIENT_ID="331e08f8-172d-43b9-835a-3108c2fcdbf3"
	export HORIZON_LAUNCHER_VERSION="${commit}"

	cargo_src_compile
}

src_install() {
	local binpath
	local bindir="/usr/libexec/${PN}"
	local desktop="${ED}/usr/share/applications/horizon-launcher.desktop"

	# Locate the compiled launcher.
	binpath=$(find "${S}" -type f \
		-path '*/release/horizon-launcher' \
		-perm /111 -print -quit)

	[[ -n ${binpath} ]] ||
		die "Could not locate the compiled horizon-launcher executable"

	einfo "Installing launcher from: ${binpath}"

	# Install the actual executable.
	exeinto "${bindir}"
	doexe "${binpath}"

	# Install wrapper to disable self-updating.
	cat > "${T}/${PN}" <<-EOF || die
		#!/bin/sh
		export HORIZON_LAUNCHER_NO_SELF_UPDATE=1
		export HORIZON_LAUNCHER_DESKTOP_EXEC="/usr/bin/${PN}"
		exec "${bindir}/${PN}" "\$@"
	EOF

	dobin "${T}/${PN}"

	# Install upstream hicolor icons, if present.
	if [[ -d "${S}/packaging/icons/hicolor" ]]; then
		insinto /usr/share/icons/hicolor
		doins -r "${S}/packaging/icons/hicolor/"*
	fi

	# Generate the desktop entry.
	HOME="${T}" \
	XDG_DATA_HOME="${ED}/usr/share" \
	HORIZON_LAUNCHER_NO_SELF_UPDATE=1 \
		"${ED}${bindir}/${PN}" desktop-entry ||
		die "Could not generate desktop entry"

	[[ -f "${desktop}" ]] ||
		die "Desktop entry was not generated"

	# Ensure the desktop entry launches the Gentoo wrapper.
	sed -i \
		-e 's|^Exec=.*|Exec=/usr/bin/horizon-launcher|' \
		"${desktop}" ||
		die "Could not fix desktop entry Exec path"

	dodoc "${S}/launcher/README.md"
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "Horizon will install Minecraft 26.3 when clicking the play button, once y
ou are signed in to a Microsoft account via the launcher."
	elog "Assets can also be imported from another client's install instead (Horizo
n will look in $XDG_CONFIG_HOME/.minecraft by default) by using the command:"
	elog "  horizon-launcher prepare"
	elog "Owning Minecraft: Java Edition on a Microsoft account is required regardl
ess."
}

pkg_postrm() {
	xdg_pkg_postrm
}
