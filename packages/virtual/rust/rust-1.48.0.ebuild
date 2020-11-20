EAPI=7
inherit multilib-build

DESCRIPTION="Virtual for Rust language compiler"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND=""
RDEPEND="~dev-lang/rust-${PV}[${MULTILIB_USEDEP}]"
