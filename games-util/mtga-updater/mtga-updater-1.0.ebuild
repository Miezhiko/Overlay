# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Update Magic: The Gathering Arena installed in a Wine prefix (bypasses MTGALauncher)"
HOMEPAGE="https://www.reddit.com/r/MagicArena/comments/1pl0m03/"

# No upstream tarball; script lives in ${FILESDIR}
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Runtime deps only; no compile-time deps
RDEPEND="
	app-arch/unzip
	app-misc/jq
	net-misc/curl
	virtual/wine
"

# Scripts only; no build step
S="${WORKDIR}"

src_unpack() {
	# Nothing to unpack; SRC_URI is empty
	:
}

src_install() {
	# Install the updater script
	newbin "${FILESDIR}/mtga-update.sh" mtga-update

	# Optional: provide a short man page or README
	dodoc <<-EOF
	mtga-update - update MTGA inside a Wine prefix

	Usage:
	  mtga-update            # update if newer version is available
	  mtga-update --force    # reinstall current version

	Environment:
	  WINEPREFIX   Wine prefix containing MTGA (default: \$HOME/.wine)
	  WINE_BIN     Wine binary to use (default: wine)

	This tool fetches the latest full installer from Wizards of the Coast
	and installs it via 'wine msiexec', bypassing MTGALauncher.exe which
	crashes under Wine when scanning the Z: drive.

	The game is expected at:
	  \$WINEPREFIX/drive_c/Program Files/Wizards of the Coast/MTGA/MTGA.exe
	EOF
}
