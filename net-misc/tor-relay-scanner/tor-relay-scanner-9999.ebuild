# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{7..10} pypy3 )

DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 python-utils-r1 wrapper

DESCRIPTION="Tor Relay availability checker, for using it as a bridge in countries with censorship"
HOMEPAGE="https://github.com/ValdikSS/tor-relay-scanner"

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ValdikSS/tor-relay-scanner.git"
	EGIT_BRANCH="main"
else
	SRC_URI="https://github.com/ValdikSS/tor-relay-scanner/archive/v${PV}.tar.gz"
	S="${WORKDIR}/tor-relay-scanner-${PV}"
fi

RESTRICT="mirror test"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/wheel"
DEPEND="${RDEPEND}"

python_install() {
	distutils-r1_python_install

	make_wrapper "${PN}.tmp" "${EPYTHON} $(python_get_sitedir)/tor_relay_scanner"
	python_newexe "${ED%/}/usr/bin/${PN}.tmp" "${PN}"
	rm "${ED%/}/usr/bin/${PN}.tmp" || die "failed to install wrapper"
}
