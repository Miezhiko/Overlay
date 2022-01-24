# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
LLVM_MAX_SLOT=13
PLOCALES="cs da de fr hr ja pl ru sl uk zh-CN zh-TW"

inherit llvm cmake virtualx xdg git-r3 desktop

DESCRIPTION="Lightweight IDE for C++/QML development centering around Qt"
HOMEPAGE="https://doc.qt.io/qtcreator/"

EGIT_REPO_URI="https://github.com/Miezhiko/Ghoul.git"
EGIT_BRANCH="mawa"
KEYWORDS="~amd64"

LICENSE="GPL-3"
SLOT="0"
QTC_PLUGINS=(android +autotest autotools:autotoolsprojectmanager baremetal bazaar beautifier boot2qt '+clang:clangcodemodel|clangformat|clangtools'
	clearcase +cmake:cmakeprojectmanager conan cppcheck ctfvisualizer cvs +designer docker +git glsl:glsleditor +help incredibuild
	+lsp:languageclient mcu:mcusupport mercurial meson:mesonprojectmanager modeling:modeleditor nim perforce perfprofiler python
	qbs:qbsprojectmanager +qmake:qmakeprojectmanager '+qml:qmldesigner|qmljseditor|qmlpreview|qmlprojectmanager|studiowelcome'
	qmlprofiler qnx remotelinux scxml:scxmleditor serialterminal silversearcher subversion valgrind webassembly +minimap +drp)
IUSE="doc systemd test webengine ${QTC_PLUGINS[@]%:*}"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	android? ( lsp )
	boot2qt? ( remotelinux )
	clang? ( lsp )
	mcu? ( baremetal cmake )
	python? ( lsp )
	qml? ( qmake )
	qnx? ( remotelinux )
"

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
	>=kde-frameworks/syntax-highlighting-5.87:5
	clang? (
		>=dev-cpp/yaml-cpp-0.6.2:=
		|| (
			sys-devel/clang:13
			sys-devel/clang:12
			sys-devel/clang:11
		)
		<sys-devel/clang-$((LLVM_MAX_SLOT + 1)):=
	)
	designer? ( >=dev-qt/designer-${QT_PV} )
	help? (
		>=dev-qt/qthelp-${QT_PV}
		webengine? ( >=dev-qt/qtwebengine-${QT_PV}[widgets] )
	)
	perfprofiler? ( dev-libs/elfutils )
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
	qml? ( >=dev-qt/qtquicktimeline-${QT_PV} )
	silversearcher? ( sys-apps/the_silver_searcher )
	subversion? ( dev-vcs/subversion )
	valgrind? ( dev-util/valgrind )
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
	local disabled_plugins
	for plugin in "${QTC_PLUGINS[@]#[+-]}"; do
		if ! use ${plugin%:*}; then
			disabled_plugins="${disabled_plugins}\n-DBUILD_PLUGIN_${plugin^^}=OFF"
		fi
	done

	local mycmakeargs=(
		${disabled_plugins}
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

	make_desktop_entry qtcreator Ghoul \
		"/usr/share/icons/hicolor/512x512/apps/QtProject-qtcreator.png" \
	Development
}
