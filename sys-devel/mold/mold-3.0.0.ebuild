# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Miezhiko overlay: forked from ::gentoo to track 3.0.0, which is a complete
# rewrite from C++ (built via cmake) to Rust (built via cargo) -- see
# https://github.com/rui314/mold/releases/tag/v3.0.0. Only this version is
# kept in this overlay; the old cmake-based packaging in ::gentoo's own
# mold-2.42.1 etc. doesn't apply at all any more.
RUST_MIN_VER="1.95"

CRATES="
	allocator-api2@0.2.21
	arrayvec@0.7.8
	blake3@1.8.7
	bstr@1.13.1
	cc@1.4.4
	cfg-if@1.0.4
	constant_time_eq@0.4.2
	cpp_demangle@0.4.5
	cpufeatures@0.3.1
	crc32fast@1.5.1
	crossbeam-deque@0.8.7
	crossbeam-epoch@0.9.20
	crossbeam-utils@0.8.22
	either@1.18.0
	equivalent@1.0.2
	find-msvc-tools@0.1.11
	flate2@1.1.10
	foldhash@0.2.0
	getrandom@0.4.3
	hashbrown@0.17.1
	jobserver@0.1.35
	libc@0.2.189
	libz-sys@1.1.29
	memchr@2.8.3
	memmap2@0.9.11
	pkg-config@0.3.34
	portable-atomic@1.15.0
	proc-macro2@1.0.107
	quote@1.0.47
	r-efi@6.0.0
	rayon-core@1.13.0
	rayon@1.12.0
	regex-automata@0.4.18
	rustc-demangle@0.1.28
	serde_core@1.0.229
	serde_derive@1.0.229
	shlex@2.0.1
	syn@3.0.4
	unicode-ident@1.0.24
	uuid@1.27.0
	vcpkg@0.2.15
	xxhash-rust@0.8.18
	zstd-safe@7.2.4
	zstd-sys@2.0.16+zstd.1.5.7
	zstd@0.13.3
"

# mimalloc's Rust bindings aren't published on crates.io; cli/Cargo.toml
# pulls them straight from git. Not feature-gated (see IUSE=mimalloc below),
# so always fetched regardless of USE.
declare -A GIT_CRATES=(
	[libmimalloc-sys]='https://github.com/rui314/mimalloc_rust;3979460494f1cd1e7f936cb8e10f41e927c9f698;mimalloc_rust-%commit%/libmimalloc-sys'
	[mimalloc]='https://github.com/rui314/mimalloc_rust;3979460494f1cd1e7f936cb8e10f41e927c9f698;mimalloc_rust-%commit%'
)

# The mimalloc_rust crate's own build.rs compiles mimalloc from C source
# that it expects to find bundled at libmimalloc-sys/c_src/mimalloc/v3/ --
# but that's a *git submodule* in the mimalloc_rust repo, and the plain
# GitHub archive tarball GIT_CRATES fetches (like any plain tarball
# download, no actual git clone involved) ships that path as an empty
# directory, submodule content omitted entirely. Fetch the pinned
# microsoft/mimalloc commit (found via the GitHub API's gitlink SHA for
# that submodule at the mimalloc_rust commit above) separately and unpack
# it into place ourselves in src_unpack. v2 isn't needed: libmimalloc-sys
# only builds v3 unless its own "v2" feature is explicitly selected, which
# nothing here does.
MIMALLOC_COMMIT="3979460494f1cd1e7f936cb8e10f41e927c9f698"
MIMALLOC_V3_COMMIT="d4881d338125e1cb7c47ba4cfb398d6f7c0c8d45"

inherit cargo

DESCRIPTION="A Modern Linker"
HOMEPAGE="https://github.com/rui314/mold"
SRC_URI="
	https://github.com/rui314/mold/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
	https://github.com/microsoft/mimalloc/archive/${MIMALLOC_V3_COMMIT}.tar.gz
		-> mimalloc-${MIMALLOC_V3_COMMIT}.tar.gz
"

# mold itself (MIT) + vendored crate licenses (dependent-crate licenses,
# mostly dual/triple-licensed permissive choices; left unresolved to their
# single effective license like pycargoebuild would, since none of this
# overlay's other Rust packages bother either):
#  - zstd-sys/zstd-safe/zstd: dual MIT/Apache-2.0, bundles the zstd C sources
#    under BSD-3 internally but we force pkg-config (system libzstd) below
#  - uuid: Apache-2.0 OR MIT
#  - cpp_demangle/arrayvec/foldhash/either/getrandom/hashbrown/memmap2/
#    portable-atomic/rayon*/serde*/unicode-ident/libc/cfg-if/crossbeam-*/
#    find-msvc-tools/jobserver/cc/shlex/vcpkg/pkg-config/r-efi/regex-automata/
#    syn/proc-macro2/quote/equivalent: MIT OR Apache-2.0
#  - bstr: MIT OR Apache-2.0 OR Unicode-3.0
#  - blake3/constant_time_eq: CC0-1.0 OR Apache-2.0 (blake3 also offers
#    Apache-2.0-with-LLVM-exceptions)
#  - cpufeatures/crc32fast/flate2/memchr/rustc-demangle/xxhash-rust: MIT OR
#    Apache-2.0 (xxhash-rust is BSD-2 upstream of the Rust rewrite; license
#    field says MIT)
LICENSE="MIT"
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 CC0-1.0 Unicode-3.0
"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug mimalloc"

# Unlike the old cmake-based packaging, this doesn't attempt to port the
# tests/ shell-script suite's sandbox/qemu workarounds (test/gdb-index-*,
# test/lto-*, test/run.sh, etc. in the old tree) to the new Rust layout; it's
# invoked through a custom `cargo test -p mold-cli` harness (see
# cli/Cargo.toml's [[test]] integration entry) that would need the same kind
# of per-script filtering redone from scratch against unfamiliar territory.
# Revisit if this overlay ever needs to validate mold's own correctness
# rather than just use it as the system linker.
RESTRICT="test"

RDEPEND="
	app-arch/zstd:=
	virtual/zlib:=
"
DEPEND="${RDEPEND}"

src_unpack() {
	cargo_src_unpack

	# See the long comment above SRC_URI: fill in the mimalloc submodule
	# content that the plain mimalloc_rust tarball ships as an empty dir.
	local mimalloc_dir="${WORKDIR}/mimalloc_rust-${MIMALLOC_COMMIT}/libmimalloc-sys/c_src/mimalloc/v3"
	[[ -d ${mimalloc_dir} ]] || die "mimalloc submodule placeholder dir not found: ${mimalloc_dir}"
	tar -xf "${DISTDIR}/mimalloc-${MIMALLOC_V3_COMMIT}.tar.gz" \
		--strip-components=1 -C "${mimalloc_dir}" || die
}

src_configure() {
	# Prefer the system libs we already depend on over cc-rs vendoring its
	# own copies from source (bug-for-bug the same reasoning as the old
	# cmake-based ebuild's -DMOLD_USE_SYSTEM_TBB=ON and system zlib/zstd/
	# xxhash/blake3 unbundling in src_prepare -- those are now plain Rust
	# crates instead of C++ libs, except zstd and zlib which still shell
	# out to the real C libraries via -sys crates).
	export ZSTD_SYS_USE_PKG_CONFIG=1

	use debug || export CARGO_PROFILE_RELEASE_DEBUG=0

	local myfeatures=(
		$(usev !mimalloc system-allocator)
	)

	# Not passing -p mold-cli here: cargo_src_configure's positional args
	# apply to every phase uniformly (per its own docs), but -p is a
	# build/test-only flag that `cargo install` rejects outright ("error:
	# unexpected argument '-p' found") -- src_install's own --path ./cli
	# already disambiguates which workspace member to install. This means
	# `cargo build` here also builds the root lib crate and the tests/
	# crate (both are workspace default-members) in addition to cli/, a
	# little wasted work but harmless.
	cargo_src_configure
}

src_install() {
	# --path overrides cargo install's default of --path ./, which is the
	# repo root / library crate, not where the "mold" binary target is.
	cargo_src_install --path ./cli

	# cargo install only knows about the "mold" binary itself; the
	# mold-wrapper.so preload shim is built as a build.rs side effect
	# (see build.rs) and dropped next to the cli crate's own build
	# output, not anywhere cargo install's manifest tracks.
	local wrapper
	wrapper=$(find "${S}/target/release" -maxdepth 1 -name mold-wrapper.so | head -n1)
	[[ -n ${wrapper} ]] || die "mold-wrapper.so not found under target/release"

	insinto /usr/$(get_libdir)/mold
	doins "${wrapper}"

	# docs/design.md and docs/execstack.md (from the old C++ tree) don't
	# exist any more; only docs/mold.md remains alongside the man page.
	dodoc docs/${PN}.md
	doman docs/${PN}.1

	dosym ${PN} /usr/bin/ld.${PN}
	dosym ${PN} /usr/bin/ld64.${PN}
	dosym -r /usr/bin/${PN} /usr/libexec/${PN}/ld
}
