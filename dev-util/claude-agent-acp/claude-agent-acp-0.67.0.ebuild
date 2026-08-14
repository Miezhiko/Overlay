# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="ACP adapter for the Claude Agent SDK, VS Code-parity"
HOMEPAGE="https://github.com/agentclientprotocol/claude-agent-acp"
SRC_URI="https://github.com/agentclientprotocol/claude-agent-acp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64"
# strip/bindist: the bundle ships a Bun-compiled native Claude CLI binary.
# network-sandbox: npm install needs to fetch packages from the registry.
RESTRICT="mirror strip bindist network-sandbox"

RDEPEND=">=net-libs/nodejs-24"
BDEPEND=">=net-libs/nodejs-24"

QA_PREBUILT="usr/lib/node_modules/${PN}/node_modules/@anthropic-ai/claude-agent-sdk-linux-x64/claude"

src_compile() {
	npm install || die
	npm run build || die
	npm prune --omit=dev || die
}

src_install() {
	local destdir="/usr/lib/node_modules/${PN}"

	dodir "${destdir}"
	cp -a "${S}/dist" "${S}/node_modules" "${S}/package.json" \
		"${ED}${destdir}/" || die

	rm -rf "${ED}${destdir}/dist/tests" || die

	fperms 0755 "${destdir}/node_modules/@anthropic-ai/claude-agent-sdk-linux-x64/claude"

	dodir /usr/bin
	cat > "${ED}/usr/bin/${PN}" <<-EOF
	#!/bin/sh
	exec node /usr/lib/node_modules/${PN}/dist/index.js "\$@"
	EOF
	fperms 0755 "/usr/bin/${PN}"
}

pkg_postinst() {
	elog "claude-agent-acp requires an Anthropic API key to function."
	elog "Set ANTHROPIC_API_KEY in your environment before running."
}
