# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg vala

SRC_URI="https://github.com/flatpak/libportal/releases/download/${PV}/libportal-${PV}.tar.xz"

DESCRIPTION="A GObject plugins library"
HOMEPAGE="https://developer.gnome.org/libpeas/stable/"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

IUSE=""

RDEPEND="
	dev-qt/qtcore
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	vala_setup
	default
}

src_configure() {
	meson_src_configure
}

src_install() {
	meson_src_install
}
