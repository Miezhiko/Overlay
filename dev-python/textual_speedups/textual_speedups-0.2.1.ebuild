# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	autocfg@1.4.0
	heck@0.5.0
	indoc@2.0.6
	libc@0.2.172
	memoffset@0.9.1
	once_cell@1.21.3
	portable-atomic@1.11.0
	proc-macro2@1.0.95
	pyo3@0.27.1
	pyo3-build-config@0.27.1
	pyo3-ffi@0.27.1
	pyo3-macros@0.27.1
	pyo3-macros-backend@0.27.1
	quote@1.0.40
	syn@2.0.101
	target-lexicon@0.13.2
	unicode-ident@1.0.18
	unindent@0.2.4
"

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=maturin
DISTUTILS_EXT=1

inherit cargo distutils-r1

DESCRIPTION="Speedups for Textual"
HOMEPAGE="https://pypi.org/project/textual-speedups"
SRC_URI="
	https://files.pythonhosted.org/packages/d4/73/bba3e9feae9ca730c32122306ddac61278a8bc47633346eddad9d52a435d/${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

RDEPEND="
    >=dev-python/textual-0.48.0[${PYTHON_USEDEP}]
"
