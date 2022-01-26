# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cuda

DESCRIPTION="Tensors and Dynamic neural networks in Python with strong GPU acceleration"
HOMEPAGE="https://pytorch.org/"

SRC_URI="https://download.pytorch.org/libtorch/cu113/libtorch-cxx11-abi-shared-with-deps-1.10.1%2Bcu113.zip -> ${P}.zip"
S="${WORKDIR}"/libtorch

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""
REQUIRED_USE=""

RDEPEND="
	dev-libs/cudnn
	dev-cpp/eigen[cuda]
	media-video/ffmpeg
	dev-cpp/gflags
	dev-cpp/glog[gflags]
	dev-libs/leveldb
	media-libs/opencv
	dev-cpp/eigen
	dev-libs/protobuf:=
	dev-libs/libuv
"

DEPEND="${RDEPEND}
	sys-process/numactl
"

src_prepare() {
	default
}

src_configure() { :; }

src_compile() { :; }

src_install() {
	insinto /opt/libtorch
	doins -r *
}
