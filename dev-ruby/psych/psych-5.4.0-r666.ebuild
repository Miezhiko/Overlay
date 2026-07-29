# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTENSIONS=(ext/psych/extconf.rb)
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="psych.gemspec"

inherit flag-o-matic ruby-fakegem

DESCRIPTION="A YAML parser and emitter"
HOMEPAGE="https://github.com/ruby/psych"
SRC_URI="https://github.com/ruby/psych/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="test"

RDEPEND=">=dev-libs/libyaml-0.2.5"
BDEPEND=">=dev-libs/libyaml-0.2.5"

ruby_add_rdepend "
	dev-ruby/date
	dev-ruby/stringio
"

ruby_add_bdepend "test? (
	dev-ruby/test-unit
	dev-ruby/test-unit-ruby-core
)"

src_configure() {
	# Ruby's mkmf always compiles C extensions with the compiler baked into
	# RbConfig::CONFIG['CC'] at the time dev-lang/ruby itself was built (clang
	# on this system); it ignores any $CC an ebuild/package.env sets. If
	# package.env still hands this package GCC-tuned CFLAGS (e.g. -mabm,
	# -mno-cldemote, -mno-kl, -mno-sgx, -mno-widekl, -mshstk), clang rejects
	# them outright and extconf.rb dies. Drop them so build works regardless
	# of what package.env is configured to inject here.
	filter-flags -mabm -mno-cldemote -mno-kl -mno-sgx -mno-widekl -mshstk

	ruby-ng_src_configure
}

all_ruby_prepare() {
	sed -e 's/__dir__/"."/' \
		-i ${RUBY_FAKEGEM_GEMSPEC}
}

each_ruby_test() {
	${RUBY} -Ilib:.:test -e 'require "lib/helper"; Dir["test/**/test_*.rb"].each{|f| require f}' || die
}
