# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

# There is an erb binary in exe but that would conflict with the ruby
# built-in version and other slots.
RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_EXTENSIONS=(ext/erb/escape/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/erb"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_EXTRAINSTALL="libexec"
RUBY_FAKEGEM_GEMSPEC="erb.gemspec"

inherit flag-o-matic ruby-fakegem

DESCRIPTION="An easy to use but powerful templating system for Ruby"
HOMEPAGE="https://github.com/ruby/erb"
SRC_URI="https://github.com/ruby/erb/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Ruby-BSD BSD-2 )"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

src_configure() {
	# Ruby's mkmf always compiles C extensions with the compiler baked into
	# RbConfig::CONFIG['CC'] at the time dev-lang/ruby itself was built
	# (clang on this system); it ignores any $CC an ebuild/package.env
	# sets. package.env hands this package GCC-tuned CFLAGS (-mabm,
	# -mno-cldemote, -mno-kl, -mno-sgx, -mno-widekl, -mshstk), which clang
	# rejects outright and extconf.rb dies. Drop them so the build works
	# regardless of what package.env is configured to inject here.
	filter-flags -mabm -mno-cldemote -mno-kl -mno-sgx -mno-widekl -mshstk

	ruby-ng_src_configure
}

all_ruby_prepare() {
	sed -e "s:_relative ': './:" \
		-e 's/git ls-files -z/find * -print0/' \
		-e "s/__dir__/File.expand_path('..', __FILE__)/" \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -rtest/lib/helper -e "Dir['test/**/test_*.rb'].each { require _1 }" || die
}
