# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs xdg-utils

DESCRIPTION="Purely functional programming language with first class types"
HOMEPAGE="https://github.com/idris-lang/Idris2/"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/idris-lang/Idris2.git"
else
	SRC_URI="https://github.com/idris-lang/Idris2/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${P^}"
fi

KEYWORDS="~amd64"

LICENSE="BSD"
SLOT="0"
IUSE="+chez doc racket test-full"
REQUIRED_USE="^^ ( chez racket )"

RDEPEND="
	chez? ( dev-scheme/chez )
	racket? ( dev-scheme/racket )
	dev-libs/gmp
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( dev-python/sphinx_rtd_theme )
	test-full? (
		dev-scheme/chez
		dev-scheme/racket
		net-libs/nodejs
	)
"

# Generated via "SCHEME", not CC
QA_FLAGS_IGNORED="usr/lib/idris2/bin/idris2_app/idris2
	usr/lib/idris2/bin/idris2_app/idris2-boot"
QA_PRESTRIPPED="${QA_FLAGS_IGNORED}"

src_prepare() {
	xdg_environment_reset
	unset IDRIS2_DATA IDRIS2_INC_CGS IDRIS2_LIBS IDRIS2_PACKAGE_PATH
	unset IDRIS2_PATH IDRIS2_PREFIX
	unset PLTUSERHOME

	tc-export AR CC CXX LD RANLIB
	export CFLAGS
	sed -i '/^CFLAGS/d' ./support/*/Makefile || die

	# Sorry... (jobserver unavailable)
	unset MAKEOPTS

	export IDRIS2_VERSION=${PV}
	export SCHEME=$(usex chez chezscheme racket)

	if use chez; then
		export IDRIS2_CG=chez
		export BOOTSTRAP_MAKE_TARGET=bootstrap
	elif use racket; then
		export IDRIS2_CG=racket
		export BOOTSTRAP_MAKE_TARGET=bootstrap-racket
	else
		die "Neither chez nor racket was chosen"
	fi

	# Fix "PREFIX"
	sed -i 's|$(HOME)/.idris2|/usr/lib/idris2|g' ./config.mk || die

	# Bad tests
	sed -i 's|"chez033",||g' ./tests/Main.idr || die

	default
}

src_configure() {
	:
}

src_compile() {
	emake SCHEME=${SCHEME} ${BOOTSTRAP_MAKE_TARGET}

	use doc && emake -C ./docs html
}

src_test() {
	emake SCHEME=${SCHEME} bootstrap-test
}

src_install() {
	# "DESTDIR" variable is not respected
	emake IDRIS2_PREFIX="${D}/usr/lib/idris2" PREFIX="${D}/usr/lib/idris2" install
	emake IDRIS2_PREFIX="${D}/usr/lib/idris2" PREFIX="${D}/usr/lib/idris2" install-with-src-libs
	emake IDRIS2_PREFIX="${D}/usr/lib/idris2" PREFIX="${D}/usr/lib/idris2" install-with-src-api

	dosym ../lib/${PN}/bin/${PN} /usr/bin/${PN}

	einstalldocs

	if use doc; then
		insinto /usr/share/doc/${PF}/
		doins -r ./docs/build/html
	fi
}
