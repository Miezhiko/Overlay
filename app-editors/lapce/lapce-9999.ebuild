# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo git-r3

EGIT_REPO_URI="https://github.com/lapce/lapce.git"
DESCRIPTION="Lightning-fast and Powerful Code Editor written in Rust"
HOMEPAGE="https://github.com/lapce/lapce"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions"
RESTRICT="mirror test"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/rust-1.57.0"
RDEPEND="${DEPEND}"

src_unpack() {
	git-r3_src_unpack

	# cargo live src unpack fails with cargo verify due git deps
	# Use FEATURES="-network-sandbox" emerge -av lapce
	# cargo_live_src_unpack
}

src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	tc-export AR CC CXX PKG_CONFIG

	set -- cargo build $(usex debug "" --release) ${ECARGO_ARGS[@]} "$@"
	einfo "${@}"
	"${@}" || die "cargo build failed"
}

src_install() {
	debug-print-function ${FUNCNAME} "$@"

	set -- cargo install $(has --path ${@} || echo --path ./) \
		--root "${ED}/usr" \
		$(usex debug --debug "") \
		${ECARGO_ARGS[@]} "$@"
	einfo "${@}"
	"${@}" || die "cargo install failed"

	rm -f "${ED}/usr/.crates.toml" || die
	rm -f "${ED}/usr/.crates2.json" || die

	# it turned out to be non-standard dir, so get rid of it future EAPI
	# and only run for EAPI=7
	# https://bugs.gentoo.org/715890
	case ${EAPI:-0} in
		7)
		if [ -d "${S}/man" ]; then
			doman "${S}/man" || return 0
		fi
		;;
	esac
}
