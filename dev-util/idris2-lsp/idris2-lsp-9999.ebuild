# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Language Server for Idris2"
HOMEPAGE="https://github.com/idris-community/idris2-lsp"

EGIT_REPO_URI="https://github.com/idris-community/idris2-lsp.git"
EGIT_SUBMODULES=()

KEYWORDS="~amd64"

LICENSE="BSD"
SLOT="0"
IUSE=""
REQUIRED_USE=""

RDEPEND="
	dev-lang/idris2
	=dev-util/idris2-lsp-lib-${PV}
"
DEPEND="${RDEPEND}"
BDEPEND=""

src_configure() {
	:
}

make_wrapper_no_exec() {
	local wrapper=$1 bin=$2 chdir=$3 libdir=$4 path=$5
	local tmpwrapper="${T}/tmp.wrapper.${wrapper##*/}"

	(
	echo '#!/bin/sh'
	if [[ -n ${libdir} ]] ; then
		local var
		if [[ ${CHOST} == *-darwin* ]] ; then
			var=DYLD_LIBRARY_PATH
		else
			var=LD_LIBRARY_PATH
		fi
		sed 's/^X//' <<-EOF || die
			if [ "\${${var}+set}" = "set" ] ; then
			X	export ${var}="\${${var}}:${EPREFIX}${libdir}"
			else
			X	export ${var}="${EPREFIX}${libdir}"
			fi
		EOF
	fi
	[[ -n ${chdir} ]] && printf 'cd "%s" &&\n' "${EPREFIX}${chdir}"
	printf '%s "$@"\n' "${bin/#\//${EPREFIX}/}"
	) > "${tmpwrapper}"
	chmod go+rx "${tmpwrapper}"

	if [[ -n ${path} ]] ; then
		(
		exeopts -m 0755
		exeinto "${path}"
		newexe "${tmpwrapper}" "${wrapper}"
		) || die
	else
		newbin "${tmpwrapper}" "${wrapper}"
	fi
}

src_install() {
	cd "${S}" || die
	IDRIS_DIR=$(/usr/bin/idris2 --libdir)
	APP_DIR="${ED}/usr/lib/idris2/bin/"
	mkdir -p "${APP_DIR}" || die
	cp -r "${S}/build/exec"/* "${APP_DIR}/" || die

	PKG_DIR="${ED}/${IDRIS_DIR}/${P}"
	mkdir -p "${PKG_DIR}" || die
	cp -r "${S}/build/ttc"/* "${PKG_DIR}" || die # installing binaries
	cp -r "${S}/src"/* "${PKG_DIR}" || die # installing sources

	# use wrapper script instead of symlink for IDRIS2_PREFIX env
	# dosym "/usr/lib/idris2/bin/${PN}" "/usr/bin/${PN}"
	make_wrapper_no_exec ${PN} "IDRIS2_PREFIX=$(idris2 --prefix) /usr/lib/idris2/bin/idris2-lsp"
}
