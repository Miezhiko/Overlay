# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The open source AI coding agent"
HOMEPAGE="https://opencode.ai https://github.com/anomalyco/opencode"

GITHUB_BASE="https://github.com/anomalyco/opencode/releases/download/v${PV}"
if [[ ${PV} == 9999 ]]; then
	PROPERTIES+=" live"
	GITHUB_BASE="https://github.com/anomalyco/opencode/releases/latest/download"
else
	SRC_URI="
		amd64? (
			cpu_flags_x86_avx2? (
				${GITHUB_BASE}/opencode-linux-x64.tar.gz -> ${P}-amd64.tar.gz
			)
			!cpu_flags_x86_avx2? (
				${GITHUB_BASE}/opencode-linux-x64-baseline.tar.gz -> ${P}-amd64-baseline.tar.gz
			)
		)
		arm64? (
			${GITHUB_BASE}/opencode-linux-arm64.tar.gz -> ${P}-arm64.tar.gz
		)
	"
	KEYWORDS="~amd64 ~arm64"
fi

S="${WORKDIR}"
LICENSE="MIT"
SLOT="0"
IUSE="cpu_flags_x86_avx2"
RESTRICT="mirror strip"

RDEPEND="sys-apps/ripgrep"

[[ ${PV} == 9999 ]] && BDEPEND+=" net-misc/curl"

QA_PREBUILT="usr/bin/opencode.real"

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		local arch suffix=""
		case ${ARCH} in
			amd64) arch="x64" ;;
			arm64) arch="arm64" ;;
			*) die "Unsupported architecture: ${ARCH}" ;;
		esac
		[[ ${ARCH} == amd64 ]] && ! use cpu_flags_x86_avx2 && suffix+="-baseline"

		local filename="opencode-linux-${arch}${suffix}.tar.gz"
		einfo "Downloading opencode latest release: ${filename}"
		curl -L -o "${WORKDIR}/${filename}" "${GITHUB_BASE}/${filename}" || die "Failed to download"
		cd "${WORKDIR}" || die
		tar -xzf "${filename}" || die "Failed to extract"
	else
		default_src_unpack
	fi
}

src_install() {
	# Install real binary under a different name
	newbin opencode opencode.real

	# Wrapper that suppresses models.dev fetch errors
	# https://github.com/anomalyco/opencode/issues/4959
	cat > "${ED}/usr/bin/opencode" <<-EOF
		#!/bin/sh
		export OPENCODE_DISABLE_MODELS_FETCH=1
		exec /usr/bin/opencode.real "\$@"
	EOF
	chmod +x "${ED}/usr/bin/opencode"
}

