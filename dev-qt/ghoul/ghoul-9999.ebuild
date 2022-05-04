# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LLVM_MAX_SLOT=14
PLOCALES="cs da de fr hr ja pl ru sl uk zh-CN zh-TW"

inherit llvm cmake virtualx xdg git-r3

DESCRIPTION="Lightweight IDE for C++/QML development centering around Qt"
HOMEPAGE="https://doc.qt.io/qtcreator/"

EGIT_REPO_URI="https://github.com/Miezhiko/Ghoul.git"
EGIT_BRANCH="mawa"
KEYWORDS="~amd64"

LICENSE="GPL-3"
SLOT="0"

IUSE="doc systemd drp test webengine +clang help serialterminal cvs git subversion mercurial cppcheck silversearcher"
RESTRICT="!test? ( test )"

# minimum Qt version required
QT_PV="5.15:5"

BDEPEND="
	>=dev-qt/linguist-tools-${QT_PV}
	virtual/pkgconfig
	doc? ( >=dev-qt/qdoc-${QT_PV} )
"
CDEPEND="
	>=dev-qt/qtconcurrent-${QT_PV}
	>=dev-qt/qtcore-${QT_PV}
	>=dev-qt/qtdeclarative-${QT_PV}[widgets]
	>=dev-qt/qtgui-${QT_PV}
	>=dev-qt/qtnetwork-${QT_PV}[ssl]
	>=dev-qt/qtprintsupport-${QT_PV}
	>=dev-qt/qtquickcontrols-${QT_PV}
	>=dev-qt/qtscript-${QT_PV}
	>=dev-qt/qtsql-${QT_PV}[sqlite]
	>=dev-qt/qtsvg-${QT_PV}
	>=dev-qt/qtwidgets-${QT_PV}
	>=dev-qt/qtx11extras-${QT_PV}
	>=dev-qt/qtxml-${QT_PV}
	!kde-frameworks/syntax-highlighting
	clang? (
		>=dev-cpp/yaml-cpp-0.6.2:=
		|| (
			sys-devel/clang:13
			sys-devel/clang:12
			sys-devel/clang:11
		)
		<sys-devel/clang-$((LLVM_MAX_SLOT + 1)):=
	)
	>=dev-qt/designer-${QT_PV}
	help? (
		>=dev-qt/qthelp-${QT_PV}
		webengine? ( >=dev-qt/qtwebengine-${QT_PV}[widgets] )
	)
	dev-libs/elfutils
	serialterminal? ( >=dev-qt/qtserialport-${QT_PV} )
	systemd? ( sys-apps/systemd:= )
	drp? ( dev-libs/discord-rpc )
"
DEPEND="${CDEPEND}
	test? (
		>=dev-qt/qtdeclarative-${QT_PV}[localstorage]
		>=dev-qt/qtquickcontrols2-${QT_PV}
		>=dev-qt/qttest-${QT_PV}
		>=dev-qt/qtxmlpatterns-${QT_PV}[qml]
	)
"
RDEPEND="${CDEPEND}
	sys-devel/gdb[python]
	cppcheck? ( dev-util/cppcheck )
	cvs? ( dev-vcs/cvs )
	git? ( dev-vcs/git )
	mercurial? ( dev-vcs/mercurial )
	>=dev-qt/qtquicktimeline-${QT_PV}
	silversearcher? ( sys-apps/the_silver_searcher )
	subversion? ( dev-vcs/subversion )
	dev-util/valgrind
"

# qt translations must also be installed or qt-creator translations won't be loaded
for x in ${PLOCALES}; do
	IUSE+=" l10n_${x}"
	RDEPEND+=" l10n_${x}? ( >=dev-qt/qttranslations-${QT_PV} )"
done
unset x

llvm_check_deps() {
	has_version -d "sys-devel/clang:${LLVM_SLOT}"
}

pkg_setup() {
	use clang && llvm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	default
}

src_configure() {
	#TEMPORARY DISABLE DRP PLUGIN
        local mycmakeargs=(
                -DBUILD_PLUGIN_DRP=OFF
                -DBUILD_PLUGIN_MCUSUPPORT=OFF
                -DBUILD_LIBRARY_KSYNTAXHIGHLIGHTING=ON
        )
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install

	dodoc dist/{changes-*,known-issues}

	# install documentation
	if use doc; then
		emake docs
		# don't use ${PF} or the doc will not be found
		insinto /usr/share/doc/qtcreator
		doins share/doc/qtcreator/qtcreator{,-dev}.qch
		docompress -x /usr/share/doc/qtcreator/qtcreator{,-dev}.qch
	fi
}
