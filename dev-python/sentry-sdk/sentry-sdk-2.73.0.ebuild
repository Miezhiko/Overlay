# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{14,15} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Python SDK for Sentry"
HOMEPAGE="https://github.com/getsentry/sentry-python"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.26.11[${PYTHON_USEDEP}]"

RESTRICT="test"
