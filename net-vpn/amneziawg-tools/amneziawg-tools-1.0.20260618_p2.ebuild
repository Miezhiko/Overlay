# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info bash-completion-r1 systemd toolchain-funcs

DESCRIPTION="Tools for configuring Amnezia-WG, such as awg(8) and awg-quick(8)"
HOMEPAGE="https://github.com/amnezia-vpn/amneziawg-tools/ https://docs.amnezia.org/documentation/amnezia-wg/"

MY_PV=${PV/_p/-}
SRC_URI="https://github.com/amnezia-vpn/amneziawg-tools/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="+awg-quick"

BDEPEND="virtual/pkgconfig"
DEPEND=""
RDEPEND="${DEPEND}
	awg-quick? (
		|| ( net-firewall/nftables net-firewall/iptables )
		virtual/resolvconf
	)
"
S="${WORKDIR}/${PN}-${MY_PV}"

wg_quick_optional_config_nob() {
	CONFIG_CHECK="$CONFIG_CHECK ~$1"
	declare -g ERROR_$1="CONFIG_$1: This option is required for automatic routing of default routes inside of awg-quick(8), though it is not required for general AmneziaWG usage."
}

pkg_setup() {
	if use awg-quick; then
		wg_quick_optional_config_nob IP_ADVANCED_ROUTER
		wg_quick_optional_config_nob IP_MULTIPLE_TABLES
		wg_quick_optional_config_nob IPV6_MULTIPLE_TABLES
		if has_version net-firewall/nftables; then
			wg_quick_optional_config_nob NF_TABLES
			wg_quick_optional_config_nob NF_TABLES_IPV4
			wg_quick_optional_config_nob NF_TABLES_IPV6
			wg_quick_optional_config_nob NFT_CT
			wg_quick_optional_config_nob NFT_FIB
			wg_quick_optional_config_nob NFT_FIB_IPV4
			wg_quick_optional_config_nob NFT_FIB_IPV6
			wg_quick_optional_config_nob NF_CONNTRACK_MARK
		elif has_version net-firewall/iptables; then
			wg_quick_optional_config_nob NETFILTER_XTABLES
			wg_quick_optional_config_nob NETFILTER_XT_MARK
			wg_quick_optional_config_nob NETFILTER_XT_CONNMARK
			wg_quick_optional_config_nob NETFILTER_XT_MATCH_COMMENT
			wg_quick_optional_config_nob NETFILTER_XT_MATCH_ADDRTYPE
			wg_quick_optional_config_nob IP6_NF_RAW
			wg_quick_optional_config_nob IP_NF_RAW
			wg_quick_optional_config_nob IP6_NF_FILTER
			wg_quick_optional_config_nob IP_NF_FILTER
		fi
	fi
	linux-info_pkg_setup
}

src_compile() {
	emake RUNSTATEDIR="${EPREFIX}/run" -C src CC="$(tc-getCC)" LD="$(tc-getLD)"
}

src_install() {
	dodoc README.md
	dodoc -r contrib
	emake \
		WITH_BASHCOMPLETION=yes \
		WITH_SYSTEMDUNITS=yes \
		WITH_WGQUICK=$(usex awg-quick) \
		DESTDIR="${D}" \
		BASHCOMPDIR="$(get_bashcompdir)" \
		SYSTEMDUNITDIR="$(systemd_get_systemunitdir)" \
		PREFIX="${EPREFIX}/usr" \
		-C src install
}
