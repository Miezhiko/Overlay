# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8

DESCRIPTION="The open source AI coding agent"
HOMEPAGE="https://opencode.ai https://github.com/anomalyco/opencode"
inherit git-r3

EGIT_REPO_URI="https://github.com/anomalyco/opencode.git"

BUN_VERSION="1.3.14"
BUN_URI="https://github.com/oven-sh/bun/releases/download/bun-v${BUN_VERSION}"
NPM_REGISTRY="https://registry.npmmirror.com"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sys-apps/ripgrep
	!dev-util/opencode-bin"
BDEPEND="
	app-arch/unzip
	net-misc/curl
	!dev-util/opencode-bin"

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
	curl -L -o "${T}/${bun_archive}" "${BUN_URI}/${bun_archive}" || die "Failed to download bun"
	
	cd "${bun_dir}" || die
	unzip -q "${T}/${bun_archive}" || die "Failed to extract bun"
	mv "${bun_dir}/bun-linux-${arch}/bun" "${bun_dir}/bun" || die "Failed to move bun binary"
	chmod +x "${bun_dir}/bun" || die
	
	# Use bun directly from its location, don't add to PATH globally
	local BUN="${bun_dir}/bun"
	
	cd "${S}" || die
	
	# Create local node_modules/.bin with just bun symlink for build
	mkdir -p node_modules/.bin || die
	ln -sf "${BUN}" node_modules/.bin/bun || die
	
	git config --global --add safe.directory "${S}" || die
	
	# Create empty models.json
	echo '[]' > "${S}/packages/opencode/models.json" || die
	export MODELS_DEV_API_JSON="${S}/packages/opencode/models.json"
	
	einfo "Installing npm dependencies..."
	# Use full path to bun
	"${BUN}" install --ignore-scripts --registry "${NPM_REGISTRY}" || die "bun install failed"
	
	if [ ! -d "node_modules" ]; then
		die "bun install failed to create node_modules"
	fi
	
	einfo "Building opencode..."
	cd packages/opencode || die
	"${BUN}" run script/build.ts --single --skip-install --skip-embed-web-ui || die "Build failed"
	
	einfo "Generating JSON schema..."
	"${BUN}" run script/schema.ts schema.json || die "Schema generation failed"
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	local arch
	case ${ARCH} in
		amd64) arch="x64" ;;
		arm64) arch="arm64" ;;
		*) die "Unsupported architecture: ${ARCH}" ;;
	esac
	
	local binary_dir="${S}/packages/opencode/dist/opencode-linux-${arch}"
	local binary_name="opencode-linux-${arch}"
	
	# Install the actual binary
	exeinto /usr/libexec/opencode
	newexe "${binary_dir}/bin/${binary_name}" "opencode.real"
	
	# Install schema
	insinto /usr/share/opencode
	doins "${S}/packages/opencode/schema.json"
	
	# Create wrapper script
	cat > "${T}/opencode" <<-EOF
		#!/bin/sh
		export OPENCODE_DISABLE_MODELS_FETCH=1
		exec /usr/libexec/opencode/opencode.real "\$@"
	EOF
	
	# Install wrapper
	exeinto /usr/bin
	doexe "${T}/opencode"
}
