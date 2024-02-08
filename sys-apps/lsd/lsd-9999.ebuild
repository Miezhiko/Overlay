# Copyright 2017-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 cargo git-r3

DESCRIPTION="An ls command with a lot of pretty colors and some other stuff."
HOMEPAGE="https://github.com/lsd-rs/lsd"
EGIT_REPO_URI="https://github.com/lsd-rs/lsd.git"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 MIT Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

QA_FLAGS_IGNORED="usr/bin/lsd"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_prepare() {
	sed -i 's/strip = true/strip = false/' Cargo.toml || die
	default
}

src_compile() {
	export SHELL_COMPLETIONS_DIR="${T}/shell_completions"
	cargo_src_compile
}

src_install() {
	cargo_src_install

	local DOCS=( CHANGELOG.md README.md doc/lsd.md )
	einstalldocs

	newbashcomp "${T}"/shell_completions/lsd.bash lsd

	insinto /usr/share/fish/vendor_completions.d
	doins "${T}"/shell_completions/lsd.fish

	insinto /usr/share/zsh/site-functions
	doins "${T}"/shell_completions/_lsd
}
