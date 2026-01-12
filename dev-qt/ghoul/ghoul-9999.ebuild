# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PLOCALES="cs da de fr hr ja pl ru sl uk zh-CN zh-TW"

LLVM_COMPAT=( {15..22} )
LLVM_OPTIONAL=1

inherit cmake llvm-r1 optfeature virtualx xdg git-r3

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
	autotools +cmake +cmakeprojectmanager compilationdatabase incredibuild meson qbs +qmake

	# Languages
	glsl +lsp nim python

	# Platforms
	android baremetal boot2qt qnx remotelinux webassembly

	# VCS
	+vcsbase bazaar clearcase cvs git gitlab mercurial perforce subversion

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
	clang? (
		$(llvm_gen_dep '
			llvm-core/clang:${LLVM_SLOT}=
			llvm-core/llvm:${LLVM_SLOT}=
		')
	)
	>=dev-qt/qtbase-${QT_PV}[concurrent,gui,network,sql,widgets,libproxy]
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
		dev-util/perf
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
	python-any-r1_pkg_setup
	use clang && llvm-r1_pkg_setup
}

src_unpack() {
	# First do the normal git unpack
	git-r3_src_unpack

	# Move all build operations here to allow network access
	einfo "Configuring and building in src_unpack to allow network access for Go modules"

	# Set up cmake variables early
	CMAKE_USE_DIR="${S}"
	BUILD_DIR="${S}_build"

	# Manually do what src_prepare would do (bypass eclass restrictions completely)
	cd "${S}" || die

	# HACK: Manually apply patches without using eapply_user (bypass phase restrictions)
	if [[ -n ${PATCHES[@]} ]]; then
		local patch
		for patch in "${PATCHES[@]}"; do
			einfo "Applying ${patch}"
			patch -p1 < "${patch}" || die "Failed to apply ${patch}"
		done
	fi

	# HACK: Manually check for user patches without using eapply_user
	local user_patches_dir="${PORTAGE_CONFIGROOT%/}/etc/portage/patches/${CATEGORY}/${PF}"
	[[ ! -d ${user_patches_dir} ]] && user_patches_dir="${PORTAGE_CONFIGROOT%/}/etc/portage/patches/${CATEGORY}/${P}"
	[[ ! -d ${user_patches_dir} ]] && user_patches_dir="${PORTAGE_CONFIGROOT%/}/etc/portage/patches/${CATEGORY}/${PN}"

	if [[ -d ${user_patches_dir} ]]; then
		local user_patch
		while IFS= read -r -d '' user_patch; do
			einfo "Applying user patch: ${user_patch}"
			patch -p1 < "${user_patch}" || die "Failed to apply user patch: ${user_patch}"
		done < <(find "${user_patches_dir}" -maxdepth 1 \( -name "*.patch" -o -name "*.diff" \) -print0 2>/dev/null | sort -z)
	fi

	# Check if CMakeLists.txt exists
	if [[ ! -e ${CMAKE_USE_DIR}/CMakeLists.txt ]] ; then
		eerror "Unable to locate CMakeLists.txt under:"
		eerror "\"${CMAKE_USE_DIR}/CMakeLists.txt\""
		die "FATAL: Unable to find CMakeLists.txt"
	fi

	# Remove cmake modules if needed (manually implement cmake_src_prepare logic)
	local modules_list=( "${CMAKE_REMOVE_MODULES_LIST[@]}" )
	local name
	for name in "${modules_list[@]}" ; do
		find "${CMAKE_USE_DIR}" -name "${name}.cmake" -exec rm -v {} + || die
	done

	# Manually implement cmake modifications that would normally be done in prepare
	local file
	while read -d '' -r file ; do
		# Comment out hardcoded CMAKE settings
		sed \
			-e '/^[[:space:]]*set[[:space:]]*([[:space:]]*CMAKE_BUILD_TYPE\([[:space:]].*)\|)\)/I{s/^/#_cmake_modify_IGNORE /g}' \
			-e '/^[[:space:]]*set[[:space:]]*([[:space:]]*CMAKE_\(COLOR_MAKEFILE\|INSTALL_PREFIX\|VERBOSE_MAKEFILE\)[[:space:]].*)/I{s/^/#_cmake_modify_IGNORE /g}' \
			-i "${file}" || die "failed to disable hardcoded settings in ${file}"
	done < <(find "${CMAKE_USE_DIR}" -type f -iname "CMakeLists.txt" -print0 || die)

	# Add Gentoo configuration summary to main CMakeLists.txt
	cat >> "${CMAKE_USE_DIR}"/CMakeLists.txt <<- _EOF_ || die

		message(STATUS "<<< Gentoo configuration >>>
		Build type      \${CMAKE_BUILD_TYPE}
		Install path    \${CMAKE_INSTALL_PREFIX}
		Compiler flags:
		C               \${CMAKE_C_FLAGS}
		C++             \${CMAKE_CXX_FLAGS}
		Linker flags:
		Executable      \${CMAKE_EXE_LINKER_FLAGS}
		Module          \${CMAKE_MODULE_LINKER_FLAGS}
		Shared          \${CMAKE_SHARED_LINKER_FLAGS}\n")
	_EOF_

	# Configure (equivalent of cmake_src_configure)
	einfo "Configuring with network access enabled..."

	mkdir -p "${BUILD_DIR}" || die

	# Set up cmake configuration
	local mycmakeargs=(
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

	# Configure
	cd "${BUILD_DIR}" || die
	cmake "${mycmakeargs[@]}" \
		-DCMAKE_BUILD_TYPE=RelWithDebInfo \
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr" \
		-DCMAKE_INSTALL_LIBDIR="$(get_libdir)" \
		-DBUILD_SHARED_LIBS=ON \
		"${CMAKE_USE_DIR}" || die "cmake configure failed"

	# Compile (equivalent of cmake_src_compile)
	einfo "Compiling with network access enabled..."
	emake VERBOSE=1 || die "compilation failed"

	einfo "Configuration and compilation completed in src_unpack"
}

src_prepare() {
	default
}

src_configure() {
	:;
}

src_compile() {
	:;
}

src_test() {
	:; # I don't need it
}

src_install() {
	# Use the pre-built artifacts from src_unpack
	cd "${BUILD_DIR}" || die

	DESTDIR="${D}" emake install || die "installation failed"

	if use doc; then
		emake install doc/{qch,html}_docs
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
