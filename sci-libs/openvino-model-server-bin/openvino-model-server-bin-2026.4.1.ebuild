# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="OpenVINO Model Server with REST and Intel NPU support"
HOMEPAGE="https://github.com/openvinotoolkit/model_server"
SRC_URI="https://github.com/openvinotoolkit/model_server/releases/download/v${PV}/ovms_ubuntu24_${PV}_python_off.tar.gz"
S="${WORKDIR}/ovms"

LICENSE="Apache-2.0 BSD BSD-2 Boost-1.0 MIT curl icu IJG libpng ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+systemd"
RESTRICT="strip"

RDEPEND="
	app-arch/zstd
	dev-libs/level-zero
	dev-libs/libxml2-compat
	dev-libs/openssl
	net-misc/curl
	>=sys-libs/glibc-2.38
	sys-libs/zlib
	sys-apps/util-linux
	>=dev-libs/intel-npu-driver-bin-1.39.1
	systemd? ( sys-apps/systemd )
"

QA_PREBUILT="opt/ovms/*"

src_install() {
	exeinto /opt/ovms/bin
	doexe bin/ovms
	insinto /opt/ovms
	doins -r include lib share
	doins metadata.json
	dodoc LICENSE
	dodoc -r thirdparty-licenses

	dobin "${FILESDIR}/ovms"
	if use systemd; then
		systemd_dounit "${FILESDIR}/ovms.service"
		insinto /etc/ovms
		doins "${FILESDIR}/ovms.conf"
	fi
}
