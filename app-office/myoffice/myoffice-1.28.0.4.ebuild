# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg unpacker

DESCRIPTION="office"
HOMEPAGE="https://myoffice.ru/products/standard-home-edition/"
SRC_URI="https://preset.myoffice-app.ru/myoffice-standard-home-edition_2022.01-${PV}_amd64.deb"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# needs full qt stack
RDEPEND="dev-qt/qtwidgets:5"

S=${WORKDIR}

src_unpack() {
	unpack_deb ${A}
}

src_compile() { :; }

make_wrapper_my() {
	local wrapper=$1 bin=$2 chdir=$3 libdir=$4 path=$5
	local tmpwrapper="${T}/tmp.wrapper.${wrapper##*/}"

	(
	echo '#!/bin/bash'
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
	# We don't want to quote ${bin} so that people can pass complex
	# things as ${bin} ... "./someprog --args"
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
	dodir /opt
	cp -pPR "${S}/usr/local/bin/myoffice-standard-home-edition" "${D}/opt/" || die
	make_wrapper_my myoffice-text "QT_PLUGIN_PATH=/opt/myoffice-standard-home-edition/lib/ /opt/myoffice-standard-home-edition/MyOffice\ Text\ Home\ Edition.sh"
	make_wrapper_my myoffice-spreadsheet "QT_PLUGIN_PATH=/opt/myoffice-standard-home-edition/lib/ /opt/myoffice-standard-home-edition/MyOffice\ Spreadsheet\ Home\ Edition.sh"
}

