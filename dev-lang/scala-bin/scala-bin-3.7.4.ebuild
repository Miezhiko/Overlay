# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

MY_PN="${PN%-*}"
MY_P="${MY_PN}3-${PV}"

DESCRIPTION="The Scala Programming Language"
HOMEPAGE="https://www.scala-lang.org"
SRC_URI="https://github.com/scala/scala3/releases/download/${PV}/scala3-${PV}-x86_64-pc-linux.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=virtual/jre-1.8
	!dev-lang/scala"

S="${WORKDIR}/scala3-${PV}-x86_64-pc-linux"

src_prepare() {
	default
	ebegin 'Cleaning .bat files'
	rm -f bin/*.bat || die
	rm -f libexec/*.bat || die
	eend $?
	
	ebegin 'Patching PROG_HOME variable in bin/ directory'
	local f
	for f in bin/*; do
		sed -i -e 's#\(PROG_HOME\)=.*#\1=/usr/share/scala-bin#' "$f" || die
	done
	
	local f
	for f in libexec/*; do
		sed -i -e 's#\(PROG_HOME\)=.*#\1=/usr/share/scala-bin#' "$f" || die
	done
	eend $?
}

src_compile() {
	:;
}

src_install() {
	ebegin 'Installing bin scripts'
	dobin bin/*
	exeinto /usr/share/${PN}/libexec
	doexe libexec/*
	insinto
	eend $?
	
	ebegin 'Installing maven2 scripts'
	cp -r ${S}/maven2 ${ED}/usr/share/${PN} || die "failed to copy maven2 dir"
	eend $?

	ebegin 'Installing jar files'

	cd lib/ || die

	java-pkg_dojar scaladoc.jar
	java-pkg_dojar scala.jar
	java-pkg_dojar with_compiler.jar

	eend $?

	cd ../ || die
	
	echo "version:=${PV}" > "${ED}"/usr/share/${PN}/VERSION
}
