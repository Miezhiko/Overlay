# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Sub-meta package for the core applications integrated with GNOME"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="+bluetooth cups"

KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

RDEPEND="
	>=gnome-base/gnome-core-libs-45.0[cups?]

	>=gnome-base/gnome-session-48.0
	>=gnome-base/gnome-settings-daemon-49.0[cups?]
	>=gnome-base/gnome-control-center-49.0[cups?]
	>=gnome-extra/gnome-color-manager-3.36.0

	>=app-crypt/gcr-3.41.1:0
	>=app-crypt/gcr-4.1.0:4
	>=gnome-base/nautilus-49.0
	>=gnome-base/gnome-keyring-42.1
	>=gnome-extra/evolution-data-server-3.50.2
	>=net-libs/glib-networking-2.78.0

	|| (
		>=app-editors/gnome-text-editor-49.0
		>=app-editors/gedit-46.1
	)
	>=app-text/evince-45.0
	>=gnome-extra/gnome-contacts-45.0
	>=media-gfx/loupe-45.1
	|| (
		>=x11-terms/gnome-terminal-3.50.1
		>=gui-apps/gnome-console-49.0
	)

	>=gnome-extra/gnome-user-docs-45.1
	>=gnome-extra/yelp-42.2

	>=x11-themes/adwaita-icon-theme-49.0

	bluetooth? ( >=net-wireless/gnome-bluetooth-42.7 )
"
DEPEND=""
BDEPEND=""

S="${WORKDIR}"
