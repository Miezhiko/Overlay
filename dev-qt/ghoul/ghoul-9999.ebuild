# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LLVM_MAX_SLOT=17
PLOCALES="cs da de fr hr ja pl ru sl uk zh-CN zh-TW"

inherit cmake llvm optfeature virtualx xdg git-r3

DESCRIPTION="Lightweight IDE for C++/QML development centering around Qt"
HOMEPAGE="https://doc.qt.io/qtcreator/"

EGIT_REPO_URI="https://github.com/Miezhiko/Ghoul.git"
EGIT_BRANCH="mawa"
KEYWORDS=""

LICENSE="GPL-3"
SLOT="0"

# In line with the standard configuration, all plugins should, by default, be built.
# Plugins don't actually depend on the package corresponding to their name.
QTCREATOR_PLUGINS=(
	# Miscq
	autotest beautifier bineditor +bookmarks +classview coco conan cppcheck
	ctfvisualizer +designer docker emacs vim help imageviewer
	macros marketplace modeling perfprofiler scxml serialterminal
	silversearcher todo valgrind welcome

	# Buildsystems
	autotools +cmake compilationdatabase incredibuild meson qbs +qmake

	# Languages
	glsl +lsp nim python

	# Platforms
	android baremetal boot2qt qnx remotelinux webassembly

	# VCS
	bazaar clearcase cvs git gitlab mercurial perforce subversion
	
	# GHOUL
	drp +minimap
)

IUSE="+clang debug doc systemd +qml tools wayland webengine
	${QTCREATOR_PLUGINS[@]}"

RESTRICT="test"

REQUIRED_USE="
	android? ( lsp )
	boot2qt? ( remotelinux )
	clang? ( lsp )
	python? ( lsp )
	qml? ( qmake )
	qnx? ( remotelinux )
"

# minimum Qt version required
QT_PV="6.4.0:6"

BDEPEND="
	>=dev-qt/qttools-${QT_PV}[linguist(+)]
	doc? ( >=dev-qt/qttools-${QT_PV}[qdoc(+)] )
"

CDEPEND="
	>=sys-devel/clang-${LLVM_MAX_SLOT}:=
	>=dev-qt/qtbase-${QT_PV}[concurrent,gui,network,sql,widgets]
	>=dev-qt/qtdeclarative-${QT_PV}
	dev-qt/qt5compat
	designer? ( >=dev-qt/qttools-${QT_PV}[designer(+)] )
	help? (
		>=dev-qt/qttools-${QT_PV}[assistant(+)]
		webengine? ( >=dev-qt/qtwebengine-${QT_PV}[widgets] )
		!webengine? ( dev-libs/gumbo )
	)
	imageviewer? ( >=dev-qt/qtsvg-${QT_PV} )
	qml? (
		>=dev-qt/qtshadertools-${QT_PV}
		tools? ( >=dev-qt/qtquick3d-${QT_PV} )
	)
	serialterminal? ( >=dev-qt/qtserialport-${QT_PV} )
	clang? (
		>=dev-cpp/yaml-cpp-0.6.2:=
	)
	perfprofiler? (
		app-arch/zstd
		dev-libs/elfutils
	)
	systemd? ( sys-apps/systemd:= )
	drp? ( dev-libs/discord-rpc )
"

DEPEND="${CDEPEND}
	dev-cpp/eigen
	dev-libs/boost
"

RDEPEND="${CDEPEND}
	wayland? (
		>=dev-qt/qtbase-${QT_PV}
		>=dev-qt/qtwayland-${QT_PV}
	)
	qml? ( >=dev-qt/qtquicktimeline-${QT_PV} )
	x11-terms/xterm
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
	llvm_pkg_setup
	export CLANG_PREFIX="$(get_llvm_prefix ${LLVM_MAX_SLOT})"
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	mycmakeargs+=(
		-DBUILD_PLUGIN_DRP=OFF
		-DBUILD_PLUGIN_MCUSUPPORT=OFF
		-DBUILD_LIBRARY_KSYNTAXHIGHLIGHTING=ON
	)

	if use help; then
		mycmakeargs+=(
			-DBUILD_HELPVIEWERBACKEND_QTWEBENGINE=$(usex webengine)
			-DHELPVIEWER_DEFAULT_BACKEND=$(usex webengine qtwebengine textbrowser)
		)
	fi

	cmake_src_configure
}

src_test() {
	:; # I don't need it
}

src_install() {
	cmake_src_install

	if use doc; then
		cmake_src_install doc/{qch,html}_docs
		docinto  html
		dodoc -r "${BUILD_DIR}"/doc/html/.
		insinto /usr/share/qt6-doc
		doins "${BUILD_DIR}"/share/doc/qtcreator/*.qch
	fi
}

pkg_postinst() {
	optfeature_header \
		"Some enabled plugins require optional dependencies for functionality:"
	use android && optfeature "android device support" \
		dev-util/android-sdk-update-manager
	if use autotest; then
		optfeature "catch testing framework support" dev-cpp/catch
		optfeature "gtest testing framework support" dev-cpp/gtest
		optfeature "boost testing framework support" dev-libs/boost
		optfeature "qt testing framework support" dev-qt/qttest
	fi
	if use beautifier; then
		optfeature "astyle auto-formatting support" dev-util/astyle
		optfeature "uncrustify auto-formatting support" dev-util/uncrustify
	fi
	use clang && optfeature "clazy QT static code analysis" dev-util/clazy
	use conan && optfeature "conan package manager integration" dev-util/conan
	use cvs && optfeature "cvs vcs integration" dev-vcs/cvs
	use docker && optfeature "using a docker image as a device" \
		app-containers/docker
	use git && optfeature "git vcs integration" dev-vcs/git
	use mercurial && optfeature "mercurial vcs integration" \
		dev-vcs/mercurial
	use meson && optfeature "meson buildsystem support" dev-util/meson
	use nim && optfeature "nim language support" dev-lang/nim
	use qbs && optfeature "QBS buildsystem support" dev-util/qbs
	use silversearcher && optfeature "code searching with silversearcher" \
		sys-apps/the_silver_searcher
	use subversion && optfeature "subversion vcs integration" \
		dev-vcs/subversion
	use valgrind && optfeature "valgrind code analysis" dev-util/valgrind
}
