# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LLVM_MAX_SLOT=15
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

IUSE="+clang debug doc systemd test +qml tools wayland webengine
	${QTCREATOR_PLUGINS[@]}"

RESTRICT="test"

REQUIRED_USE="
	android? ( lsp )
	boot2qt? ( remotelinux )
	clang? ( lsp )
	python? ( lsp )
	qml? ( qmake )
	qnx? ( remotelinux )
	test? ( qbs qmake )
"

# minimum Qt version required
QT_PV="6.4.0:6"

BDEPEND="
	>=dev-qt/qttools-${QT_PV}[linguist(+)]
	doc? ( >=dev-qt/qttools-${QT_PV}[qdoc(+)] )
"

CDEPEND="
	<sys-devel/clang-$((LLVM_MAX_SLOT + 1)):=
	|| (
		sys-devel/clang:14
		sys-devel/clang:13
	)
	>=dev-qt/qt5compat-${QT_PV}
	>=dev-qt/qtbase-${QT_PV}[concurrent,gui,network,sql,widgets]
	>=dev-qt/qtdeclarative-${QT_PV}
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
		sys-devel/clang:14=
	)
	perfprofiler? (
		app-arch/zstd
		dev-libs/elfutils
	)
	systemd? ( sys-apps/systemd:= )
	drp? ( dev-libs/discord-rpc )
"

DEPEND="${CDEPEND}
	test? (
		dev-cpp/benchmark
		dev-cpp/eigen
		dev-libs/boost
		>=dev-qt/qtbase-${QT_PV}[test]
	)
"

RDEPEND="${CDEPEND}
	wayland? (
		>=dev-qt/qtbase-${QT_PV}[egl]
		>=dev-qt/qtwayland-${QT_PV}
	)
	qml? ( >=dev-qt/qtquicktimeline-${QT_PV} )
"

# qt translations must also be installed or qt-creator translations won't be loaded
for x in ${PLOCALES}; do
	IUSE+=" l10n_${x}"
	RDEPEND+=" l10n_${x}? ( >=dev-qt/qttranslations-${QT_PV} )"
done
unset x


# FUNCTION: cmake_use_remove_addsubdirectory
# USAGE: <flag> <subdir> <files...>
# DESCRIPTION:
# <flag> is the name of a flag in IUSE.
# <subdir> is the  name of a directory called with add_subdirectory().
# <files...> is a list of one or more qmake project files.
#
# This function patches <files> to remove add_subdirectory(<subdir>) from cmake
# when <flag> is disabled, otherwise it does nothing. This can be useful to
# avoid an automagic dependency when a subdirectory is added in cmake but the
# corresponding feature USE flag is disabled. Similar to qt_use_disable_config()
# from /qt5-build.eclass
cmake_use_remove_addsubdirectory() {
	[[ $# -ge 3 ]] || die "${FUNCNAME}() requires at least three arguments"
	local flag=$1
	local subdir=$2
	shift 2

	if ! use "${flag}"; then
		echo "$@" | xargs sed -i -e "/add_subdirectory(${subdir})/d" || die
	fi
}

llvm_check_deps() {
	has_version -d "sys-devel/clang:${LLVM_SLOT}"
}

pkg_setup() {
	llvm_pkg_setup
	export CLANG_PREFIX="$(get_llvm_prefix ${LLVM_MAX_SLOT})"
}

src_prepare() {
	cmake_src_prepare

	# Remove automagic dep for qt6
	sed -e "/^find_package(Qt6/,/else()/ s|if (NOT Qt6_FOUND)|if (0)|" \
		-i cmake/FindQt5.cmake || die

	# qt-creator hardcodes the CLANG_INCLUDE_DIR to the default.
	# However, in sys-devel/clang, the directory changes with respect to
	# -DCLANG_RESOURCE_DIR.  We sed in the correct include dir.
	local res_dir="$(${CLANG_PREFIX}/bin/clang -print-resource-dir || die)"
	sed -e "/\w*CLANG_INCLUDE_DIR=/s|=.*|=\"${res_dir}/include\"|" \
		-i src/plugins/clangtools/CMakeLists.txt || die

	cmake_use_remove_addsubdirectory glsl glsl src/libs/CMakeLists.txt
	cmake_use_remove_addsubdirectory lsp languageserverprotocol \
		src/libs/CMakeLists.txt tests/auto/CMakeLists.txt
	cmake_use_remove_addsubdirectory qml advanceddockingsystem \
		src/libs/CMakeLists.txt
	cmake_use_remove_addsubdirectory modeling modelinglib \
		src/libs/CMakeLists.txt

	# PLUGIN_RECOMMENDS is treated like a hard-dependency
	sed -i -e '/PLUGIN_RECOMMENDS /d' \
		src/plugins/*/CMakeLists.txt || die

	# fix translations
	local languages=()
	for lang in ${PLOCALES}; do
		use l10n_${lang} && languages+=( "${lang/-/_}" )
	done
	sed -i -e "s|^set(languages.*|set(languages ${languages[*]})|" \
		share/qtcreator/translations/CMakeLists.txt || die

	# remove bundled yaml-cpp
	rm -r src/libs/3rdparty/yaml-cpp || die

	# remove bundled qbs
	rm -r src/shared/qbs || die

	# remove bundled litehtml
	rm -r src/libs/qlitehtml || die
}

src_configure() {
	mycmakeargs+=(
		-DWITH_TESTS=$(usex test)
		-DWITH_DEBUG_CMAKE=$(usex debug)

		# Don't use SANITIZE_FLAGS to pass extra CXXFLAGS
		-DWITH_SANITIZE=NO

		-DWITH_DOCS=$(usex doc)
		-DBUILD_DEVELOPER_DOCS=$(usex doc)

		# Install failure.  Disable for now
		-DWITH_ONLINE_DOCS=NO

		# Force enable base plugins that most other plugins depend on
		# to simplify the dependency graph
		-DBUILD_PLUGIN_CORE=YES
		-DBUILD_PLUGIN_CODEPASTER=YES
		-DBUILD_PLUGIN_CPPEDITOR=YES
		-DBUILD_PLUGIN_DEBUGGER=YES
		-DBUILD_PLUGIN_DIFFEDITOR=YES
		-DBUILD_PLUGIN_GENERICPROJECTMANAGER=YES
		-DBUILD_PLUGIN_PROJECTEXPLORER=YES
		-DBUILD_PLUGIN_QMLJSTOOLS=YES
		-DBUILD_PLUGIN_QTSUPPORT=YES
		-DBUILD_PLUGIN_RESOURCEEDITOR=YES
		-DBUILD_PLUGIN_TEXTEDITOR=YES
		-DBUILD_PLUGIN_VCSBASE=YES

		# Misc
		-DBUILD_PLUGIN_AUTOTEST=$(usex autotest)
		-DBUILD_PLUGIN_BEAUTIFIER=$(usex beautifier)
		-DBUILD_PLUGIN_BINEDITOR=$(usex bineditor)
		-DBUILD_PLUGIN_BOOKMARKS=$(usex bookmarks)
		-DBUILD_PLUGIN_CLASSVIEW=$(usex classview)
		-DBUILD_PLUGIN_COCO=$(usex coco)
		-DBUILD_PLUGIN_CONAN=$(usex conan)
		-DBUILD_PLUGIN_CPPCHECK=$(usex cppcheck)
		-DBUILD_PLUGIN_CTFVISUALIZER=$(usex ctfvisualizer)
		-DBUILD_PLUGIN_DESIGNER=$(usex designer)
		-DBUILD_PLUGIN_DOCKER=$(usex docker)
		-DBUILD_PLUGIN_EMACSKEYS=$(usex emacs)
		-DBUILD_PLUGIN_FAKEVIM=$(usex vim)
		-DBUILD_PLUGIN_HELP=$(usex help)
		-DBUILD_PLUGIN_IMAGEVIEWER=$(usex imageviewer)
		-DBUILD_PLUGIN_MACROS=$(usex macros)
		-DBUILD_PLUGIN_MARKETPLACE=$(usex marketplace)
		-DBUILD_PLUGIN_MODELEDITOR=$(usex modeling)
		-DBUILD_PLUGIN_PERFPROFILER=$(usex perfprofiler)
		-DBUILD_PLUGIN_SCXMLEDITOR=$(usex scxml)
		-DBUILD_PLUGIN_SERIALTERMINAL=$(usex serialterminal)
		-DBUILD_PLUGIN_SILVERSEARCHER=$(usex silversearcher)
		-DBUILD_PLUGIN_TODO=$(usex todo)
		-DBUILD_PLUGIN_VALGRIND=$(usex valgrind)
		-DBUILD_PLUGIN_WELCOME=$(usex welcome)

		# Buildsystems
		-DBUILD_PLUGIN_AUTOTOOLSPROJECTMANAGER=$(usex autotools)
		-DBUILD_PLUGIN_CMAKEPROJECTMANAGER=$(usex cmake)
		-DBUILD_PLUGIN_COMPILATIONDATABASEPROJECTMANAGER=$(usex compilationdatabase)
		-DBUILD_PLUGIN_MESONPROJECTMANAGER=$(usex meson)
		-DBUILD_PLUGIN_QBSPROJECTMANAGER=$(usex qbs)
		-DBUILD_PLUGIN_QMAKEPROJECTMANAGER=$(usex qmake)

		# Languages
		-DBUILD_PLUGIN_GLSLEDITOR=$(usex glsl)
		-DBUILD_PLUGIN_LANGUAGECLIENT=$(usex lsp)
		-DBUILD_PLUGIN_NIM=$(usex nim)
		-DBUILD_PLUGIN_PYTHON=$(usex python)

		# Platforms
		-DBUILD_PLUGIN_ANDROID=$(usex android)
		-DBUILD_PLUGIN_BAREMETAL=$(usex baremetal)
		-DBUILD_PLUGIN_BOOT2QT=$(usex boot2qt)
		-DBUILD_PLUGIN_QNX=$(usex qnx)
		-DBUILD_PLUGIN_REMOTELINUX=$(usex remotelinux)
		-DBUILD_PLUGIN_WEBASSEMBLY=$(usex webassembly)

		# VCS
		-DBUILD_PLUGIN_BAZAAR=$(usex bazaar)
		-DBUILD_PLUGIN_CLEARCASE=$(usex clearcase)
		-DBUILD_PLUGIN_CVS=$(usex cvs)
		-DBUILD_PLUGIN_GIT=$(usex git)
		-DBUILD_PLUGIN_GITLAB=$(usex gitlab)
		-DBUILD_PLUGIN_MERCURIAL=$(usex mercurial)
		-DBUILD_PLUGIN_PERFORCE=$(usex perforce)
		-DBUILD_PLUGIN_SUBVERSION=$(usex subversion)

		# Executables
		-DBUILD_CPLUSPLUS_TOOLS=$(usex tools)
		-DBUILD_EXECUTABLE_BUILDOUTPUTPARSER=$(usex qmake)
		-DBUILD_EXECUTABLE_PERFPARSER=$(usex perfprofiler)
		-DBUILD_EXECUTABLE_QML2PUPPET=$(usex qml)

		# Use portage to update
		-DBUILD_PLUGIN_UPDATEINFO=NO

		# Not usable in linux environment
		-DBUILD_PLUGIN_IOS=NO

		# Clang stuff
		-DClang_DIR="${CLANG_PREFIX}/$(get_libdir)/cmake/clang"
		-DLLVM_DIR="${CLANG_PREFIX}/$(get_libdir)/cmake/llvm"
		-DCLANGTOOLING_LINK_CLANG_DYLIB=YES
		-DBUILD_PLUGIN_CLANGCODEMODEL=$(usex clang)
		-DBUILD_PLUGIN_CLANGFORMAT=$(usex clang)
		-DBUILD_PLUGIN_CLANGTOOLS=$(usex clang)

		# QML stuff
		-DBUILD_PLUGIN_QMLDESIGNER=$(usex qml)
		-DBUILD_PLUGIN_QMLJSEDITOR=$(usex qml)
		-DBUILD_PLUGIN_QMLPREVIEW=$(usex qml)
		-DBUILD_PLUGIN_QMLPROFILER=$(usex qml)
		-DBUILD_PLUGIN_QMLPROJECTMANAGER=$(usex qml)
		-DBUILD_PLUGIN_STUDIOWELCOME=$(usex qml)
		-DWITH_QMLDOM=OFF

		# Don't spam "created by a different GCC executable [-Winvalid-pch]"
		-DBUILD_WITH_PCH=NO

		# An entire mode devoted to a giant "Hello World!" button that does nothing.
		# TODO: Maybe add to an "examples" USE flag
		-DBUILD_PLUGIN_HELLOWORLD=NO

		# Ghoul part
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
	virtx cmake_src_test
}

src_install() {
	cmake_src_install

	if use doc; then
		cmake_src_install doc/{qch,html}_docs
		docinto  html
		dodoc -r "${BUILD_DIR}"/doc/html/.
		insinto /usr/share/qt5-doc
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
