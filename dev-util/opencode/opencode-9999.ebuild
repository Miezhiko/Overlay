# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8

DESCRIPTION="The open source AI coding agent"
HOMEPAGE="https://opencode.ai https://github.com/anomalyco/opencode"
inherit git-r3

EGIT_REPO_URI="https://github.com/anomalyco/opencode.git"
BUN_VERSION="1.3.14"
BUN_URI="https://github.com/oven-sh/bun/releases/download/bun-v${BUN_VERSION}"
NPM_REGISTRY="${NPM_REGISTRY:-https://registry.npmjs.org}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# git-r3 fetches happen outside the sandboxed phases, but curl (bun download)
# and `bun install` both need network access during src_unpack, which Portage
# blocks by default under FEATURES=network-sandbox. This is REQUIRED or the
# build will silently produce a broken/stub binary instead of failing loudly.
RESTRICT="network-sandbox"

RDEPEND="sys-apps/ripgrep
	!dev-util/opencode-bin"
BDEPEND="
	app-arch/unzip
	net-misc/curl
	!dev-util/opencode-bin
"

S="${WORKDIR}/${P}"

src_unpack() {
	git-r3_src_unpack

	local arch
	case ${ARCH} in
		amd64) arch="x64" ;;
		arm64) arch="arm64" ;;
		*) die "Unsupported architecture: ${ARCH}" ;;
	esac

	local bun_archive="bun-linux-${arch}.zip"
	local bun_dir="${T}/bun"
	mkdir -p "${bun_dir}" || die

	einfo "Downloading bun ${BUN_VERSION} for building..."
	curl -fL -o "${T}/${bun_archive}" "${BUN_URI}/${bun_archive}" || die "Failed to download bun"

	cd "${bun_dir}" || die
	unzip -q "${T}/${bun_archive}" || die "Failed to extract bun"
	mv "${bun_dir}/bun-linux-${arch}/bun" "${bun_dir}/bun" || die "Failed to move bun binary"
	chmod +x "${bun_dir}/bun" || die
	export PATH="${bun_dir}:${PATH}"

	# Sanity: make sure we're actually picking up the bun we just fetched,
	# not some stale one already on PATH.
	local bun_bin
	bun_bin="$(command -v bun)" || die "bun not found on PATH after setup"
	[[ "${bun_bin}" == "${bun_dir}/bun" ]] || die "Wrong bun resolved: ${bun_bin}"

	cd "${S}" || die
	git config --global --add safe.directory "${S}" || die

	# packages/console, packages/stats, and packages/enterprise are the
	# web dashboard workspaces - unrelated to the opencode CLI we're
	# building. Their package.json pins @solidjs/start to a specific
	# ephemeral pkg.pr.new PR-preview build. That preview build has since
	# been rotated out / expired and now 403s, which makes a full
	# workspace-root `bun install` fail outright (bun does exit non-zero
	# for this, but be aware: if this check is ever removed and the
	# failure goes uncaught, the compile step below can still emit a
	# valid-looking-but-unbundled executable). Drop these workspaces
	# entirely so install never needs to resolve that dependency.
	rm -rf packages/console packages/stats packages/enterprise || die
	rm -f bun.lock || die

	echo '[]' > "${S}/packages/opencode/models.json" || die
	export MODELS_DEV_API_JSON="${S}/packages/opencode/models.json"

	einfo "Installing npm dependencies from ${NPM_REGISTRY}..."
	bun install --ignore-scripts --registry "${NPM_REGISTRY}" \
		|| die "bun install failed - check network access (RESTRICT=network-sandbox) and registry reachability"

	einfo "Building opencode..."
	cd packages/opencode || die
	# NOTE: do NOT pass --skip-install here. That flag assumes a prior CI step
	# already ran `bun install --os="*" --cpu="*"` for @opentui/core,
	# @parcel/watcher, and @ff-labs/fff-bun across every target platform.
	# Skipping it without that prior step can leave native bindings the TUI
	# and parser worker need missing/wrong, which makes `Bun.build({compile})`
	# silently emit an unbundled (bare bun) executable instead of failing.
	bun run script/build.ts --single --skip-embed-web-ui \
		|| die "Build failed"

	local out_bin="${S}/packages/opencode/dist/opencode-linux-${arch}/bin/opencode"
	[ -x "${out_bin}" ] || die "Expected compiled binary not found at ${out_bin}"

	# Guard against getting a bare bun passthrough binary instead of the real
	# bundled app. `--version`/`--help` alone don't catch this reliably since
	# bare bun answers those too; the real tell is bun's top-level usage
	# banner, which only appears on a bare/no-arg invocation.
	local bare_output
	bare_output="$(printf '' | timeout 5 "${out_bin}" 2>&1 | head -n1)"
	case "${bare_output}" in
		*"fast JavaScript runtime"*)
			die "Compiled binary is a bare bun passthrough, not opencode - build did not bundle the entrypoint correctly"
			;;
	esac

	einfo "Generating JSON schema..."
	bun run script/schema.ts schema.json || die "Schema generation failed"
}

src_configure() { :; }
src_compile() { :; }

src_install() {
	local arch
	case ${ARCH} in
		amd64) arch="x64" ;;
		arm64) arch="arm64" ;;
		*) die "Unsupported architecture: ${ARCH}" ;;
	esac

	local binary_dir="${S}/packages/opencode/dist/opencode-linux-${arch}"
	newbin "${binary_dir}/bin/opencode" "opencode.real"

	# CRITICAL: Bun's --compile feature appends the bundled JS payload as
	# custom data past the normal ELF sections - it is not standard debug
	# info or unneeded symbols. Portage's default auto-strip (FEATURES=strip)
	# does not understand this format and will truncate/corrupt that
	# payload, silently turning the installed binary back into bare bun
	# (it will run, but behave as if nothing was ever bundled into it).
	# dostrip -x exempts this specific file from stripping.
	dostrip -x /usr/bin/opencode.real

	insinto /usr/share/opencode
	doins "${S}/packages/opencode/schema.json"

	cat > "${ED}/usr/bin/opencode" <<-EOF
		#!/bin/sh
		export OPENCODE_DISABLE_MODELS_FETCH=1
		exec /usr/bin/opencode.real "\$@"
	EOF
	chmod +x "${ED}/usr/bin/opencode" || die
}
