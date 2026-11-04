# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.85.0"

CRATES="
	adler2@2.0.1
	aes@0.9.3
	ahash@0.8.12
	aho-corasick@1.1.5
	alloc-no-stdlib@3.0.0
	alloc-stdlib@0.3.0
	android_system_properties@0.1.6
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	anyhow@1.0.104
	arboard@3.7.0
	ashpd@0.11.1
	async-broadcast@0.7.2
	async-channel@2.5.0
	async-executor@1.14.0
	async-fs@2.2.0
	async-io@2.6.0
	async-lock@3.4.2
	async-net@2.0.0
	async-process@2.5.0
	async-recursion@1.2.0
	async-signal@0.2.14
	async-task@4.7.1
	async-trait@0.1.92
	atk-sys@0.18.2
	atk@0.18.2
	atomic-waker@1.1.2
	autocfg@1.5.1
	base64@0.21.7
	base64@0.22.1
	base64@0.23.1
	bit-set@0.8.0
	bit-vec@0.8.0
	bitflags@1.3.2
	bitflags@2.13.2
	block-buffer@0.10.4
	block-buffer@0.12.1
	block-padding@0.4.2
	block2@0.6.2
	blocking@1.7.0
	brotli-decompressor@6.0.1
	brotli@9.0.0
	bs58@0.5.1
	bstr@1.13.1
	bumpalo@3.20.3
	bytemuck@1.25.2
	byteorder-lite@0.1.0
	byteorder@1.5.0
	bytes@1.12.1
	cairo-rs@0.18.5
	cairo-sys-rs@0.18.2
	camino@1.2.6
	cargo-platform@0.1.9
	cargo_metadata@0.19.2
	cargo_toml@1.0.1
	cbc@0.2.1
	cc@1.8.0
	cesu8@1.1.0
	cfb@0.14.0
	cfg-expr@0.15.8
	cfg-if@1.0.5
	cfg_aliases@0.2.2
	chacha20@0.10.2
	chrono@0.4.45
	cipher@0.5.2
	clap@4.6.7
	clap_builder@4.6.7
	clap_derive@4.6.7
	clap_lex@1.1.1
	clipboard-win@5.4.1
	cmov@0.5.4
	colorchoice@1.0.5
	combine@4.6.9
	concurrent-queue@2.5.0
	const-oid@0.10.2
	cookie@0.18.2
	core-foundation-sys@0.8.7
	core-foundation@0.10.1
	core-graphics-types@0.2.0
	core-graphics@0.25.0
	cpubits@0.1.1
	cpufeatures@0.2.17
	cpufeatures@0.3.1
	crc32fast@1.5.2
	crossbeam-channel@0.5.17
	crossbeam-utils@0.8.23
	crunchy@0.2.4
	crypto-common@0.1.7
	crypto-common@0.2.2
	cssparser-macros@0.7.1
	cssparser@0.37.0
	csv-core@0.1.13
	csv@1.4.0
	ctor@1.0.13
	ctutils@0.4.4
	darling@0.24.1
	darling_core@0.24.1
	darling_macro@0.24.1
	dbus@0.9.12
	defmt-macros@1.2.0
	defmt-parser@1.1.0
	defmt@1.2.0
	deranged@0.5.9
	derive_more-impl@2.1.1
	derive_more@2.1.1
	digest@0.10.7
	digest@0.11.3
	dirs-sys@0.5.0
	dirs@7.0.0
	dispatch2@0.3.1
	displaydoc@0.2.7
	dlib@0.5.3
	dlopen2@0.8.2
	dlopen2_derive@0.4.3
	dom_query@0.28.0
	downcast-rs@1.2.1
	dpi@0.1.2
	dtoa-short@0.3.5
	dtoa@1.0.11
	dunce@1.0.5
	dyn-clone@1.0.20
	embed-resource@3.0.12
	embed_plist@1.2.2
	endi@1.1.1
	enumflags2@0.7.12
	enumflags2_derive@0.7.12
	equivalent@1.0.3
	erased-serde@0.4.10
	errno@0.3.14
	error-code@3.4.0
	event-listener-strategy@0.5.4
	event-listener@5.4.2
	fallible-iterator@0.3.0
	fallible-streaming-iterator@0.1.9
	fastrand@2.5.0
	fax@0.2.7
	fdeflate@0.3.7
	field-offset@0.3.6
	find-msvc-tools@0.1.14
	fixedbitset@0.5.7
	flate2@1.1.10
	fnv@1.0.7
	foldhash@0.1.5
	foldhash@0.2.0
	foreign-types-macros@0.2.4
	foreign-types-shared@0.3.1
	foreign-types@0.5.0
	form_urlencoded@1.2.2
	fs2@0.4.3
	futures-channel@0.3.34
	futures-core@0.3.34
	futures-executor@0.3.34
	futures-io@0.3.34
	futures-lite@2.6.1
	futures-macro@0.3.34
	futures-sink@0.3.34
	futures-task@0.3.34
	futures-util@0.3.34
	gdk-pixbuf-sys@0.18.0
	gdk-pixbuf@0.18.5
	gdk-sys@0.18.2
	gdk@0.18.2
	gdkwayland-sys@0.18.2
	gdkx11-sys@0.18.2
	gdkx11@0.18.2
	generic-array@0.14.7
	gethostname@1.1.0
	getrandom@0.2.17
	getrandom@0.3.4
	getrandom@0.4.3
	gio-sys@0.18.1
	gio@0.18.4
	glib-macros@0.18.5
	glib-sys@0.18.1
	glib@0.18.5
	glob@0.3.4
	globset@0.4.20
	gobject-sys@0.18.0
	gtk-sys@0.18.2
	gtk3-macros@0.18.2
	gtk@0.18.2
	half@2.7.1
	hashbrown@0.12.3
	hashbrown@0.14.5
	hashbrown@0.15.5
	hashbrown@0.17.1
	hashlink@0.9.1
	heck@0.4.1
	heck@0.5.0
	hermit-abi@0.5.3
	hex@0.4.3
	hkdf@0.13.0
	hmac@0.13.0
	html5ever@0.39.0
	http-body-util@0.1.5
	http-body@1.1.0
	http@1.5.0
	httparse@1.10.1
	hybrid-array@0.4.15
	hyper-rustls@0.27.10
	hyper-util@0.1.21
	hyper@1.12.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.65
	ico@0.5.0
	icu_collections@2.3.0
	icu_locale_core@2.3.0
	icu_normalizer@2.3.0
	icu_normalizer_data@2.3.0
	icu_properties@2.3.0
	icu_properties_data@2.3.0
	icu_provider@2.3.1
	ident_case@1.0.1
	idna@1.1.0
	idna_adapter@1.2.2
	image@0.25.10
	indexmap@1.9.3
	indexmap@2.14.2
	infer@0.22.0
	inout@0.2.4
	ipnet@2.12.2
	is-docker@0.2.0
	is-wsl@0.4.0
	is_terminal_polyfill@1.70.2
	itoa@1.0.18
	javascriptcore-rs-sys@1.1.1
	javascriptcore-rs@1.1.2
	jiff-core@0.1.1
	jiff-static@0.2.38
	jiff-tzdb-platform@0.1.3
	jiff-tzdb@0.1.9
	jiff@0.2.38
	jni-sys-macros@0.4.1
	jni-sys@0.3.1
	jni-sys@0.4.1
	jni@0.21.1
	js-sys@0.3.106
	json-patch@4.2.0
	jsonptr@0.7.1
	keyboard-types@0.8.3
	ksni@0.3.6
	libappindicator-sys@0.9.0
	libappindicator@0.9.0
	libc@0.2.191
	libdbus-sys@0.2.7
	libloading@0.7.4
	libloading@0.8.9
	libredox@0.1.25
	libsqlite3-sys@0.30.1
	linux-raw-sys@0.12.1
	litemap@0.8.3
	lock_api@0.4.14
	log@0.4.34
	lru-slab@0.1.3
	mac-notification-sys@0.6.15
	markup5ever@0.39.0
	memchr@2.8.3
	memoffset@0.9.1
	mime@0.3.17
	mime_guess@2.0.5
	miniz_oxide@0.8.9
	miniz_oxide@0.9.1
	mio@1.2.4
	moxcms@0.8.1
	muda@0.20.0
	ndk-context@0.1.1
	ndk-sys@0.6.0+11769913
	ndk@0.9.0
	new_debug_unreachable@1.0.6
	nix@0.31.3
	nom@8.0.0
	notify-rust@4.18.2
	num-bigint@0.4.8
	num-complex@0.4.6
	num-conv@0.2.2
	num-integer@0.1.47
	num-iter@0.1.46
	num-rational@0.4.2
	num-traits@0.2.19
	num@0.4.3
	num_enum@0.7.6
	num_enum_derive@0.7.6
	objc2-app-kit@0.3.2
	objc2-cloud-kit@0.3.2
	objc2-core-data@0.3.2
	objc2-core-foundation@0.3.2
	objc2-core-graphics@0.3.2
	objc2-core-image@0.3.2
	objc2-core-location@0.3.2
	objc2-core-text@0.3.2
	objc2-encode@4.1.0
	objc2-exception-helper@0.1.1
	objc2-foundation@0.3.2
	objc2-io-surface@0.3.2
	objc2-quartz-core@0.3.2
	objc2-ui-kit@0.3.2
	objc2-user-notifications@0.3.2
	objc2-web-kit@0.3.2
	objc2@0.6.5
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	open@5.4.4
	option-ext@0.2.0
	ordered-stream@0.2.0
	os_pipe@1.2.3
	pango-sys@0.18.0
	pango@0.18.3
	parking@2.2.1
	parking_lot@0.12.5
	parking_lot_core@0.9.12
	pastey@0.2.3
	percent-encoding@2.3.2
	petgraph@0.8.3
	phf@0.13.1
	phf_codegen@0.13.1
	phf_generator@0.13.1
	phf_macros@0.13.1
	phf_shared@0.13.1
	pin-project-lite@0.2.17
	piper@0.2.5
	pkg-config@0.3.34
	plist@1.10.1
	png@0.17.16
	png@0.18.1
	polling@3.11.0
	pollster@0.4.0
	portable-atomic-util@0.2.8
	portable-atomic@1.15.0
	potential_utf@0.1.6
	powerfmt@0.2.1
	ppv-lite86@0.2.21
	precomputed-hash@0.1.1
	proc-macro-crate@1.3.1
	proc-macro-crate@2.0.2
	proc-macro-crate@3.5.0
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.107
	pxfm@0.1.30
	quick-error@2.0.1
	quick-xml@0.41.0
	quick-xml@0.42.0
	quinn-proto@0.11.19
	quinn-udp@0.5.16
	quinn@0.11.12
	quote@1.0.47
	r-efi@5.3.0
	r-efi@6.0.0
	rand@0.10.3
	rand@0.9.5
	rand_chacha@0.9.0
	rand_core@0.10.1
	rand_core@0.9.5
	rand_pcg@0.10.2
	raw-window-handle@0.6.2
	redox_syscall@0.5.18
	redox_users@0.5.3
	ref-cast-impl@1.0.27
	ref-cast@1.0.27
	regex-automata@0.4.18
	regex-syntax@0.8.11
	regex@1.13.1
	reqwest@0.12.28
	reqwest@0.13.5
	rfd@0.15.4
	ring@0.17.14
	rusqlite@0.32.1
	rustc-hash@2.1.3
	rustc_version@0.4.1
	rustix@1.1.5
	rustls-pki-types@1.15.1
	rustls-webpki@0.103.16
	rustls@0.23.46
	rustversion@1.0.23
	ryu@1.0.23
	same-file@1.0.6
	schemars@0.8.22
	schemars@0.9.0
	schemars@1.2.3
	schemars_derive@0.8.22
	scoped-tls@1.0.1
	scopeguard@1.2.0
	secret-service@5.2.0
	selectors@0.38.0
	semver@1.0.28
	serde-untagged@0.1.9
	serde@1.0.229
	serde_core@1.0.229
	serde_derive@1.0.229
	serde_derive_internals@0.29.1
	serde_json@1.0.154
	serde_repr@0.1.21
	serde_spanned@0.6.9
	serde_spanned@1.1.2
	serde_urlencoded@0.7.1
	serde_with@3.24.0
	serde_with_macros@3.24.0
	serialize-to-javascript-impl@0.1.2
	serialize-to-javascript@0.1.2
	servo_arc@0.4.3
	sha2@0.10.9
	sha2@0.11.1
	shlex@2.0.1
	signal-hook-registry@1.4.8
	signal-hook@0.3.18
	simd-adler32@0.3.10
	siphasher@1.0.4
	slab@0.4.12
	smallvec@1.16.3
	socket2@0.6.5
	softbuffer@0.4.8
	soup3-sys@0.5.0
	soup3@0.5.0
	stable_deref_trait@1.2.1
	static_vcruntime@3.0.0
	string_cache@0.9.0
	string_cache_codegen@0.6.1
	strsim@0.11.1
	subtle@2.6.1
	swift-rs@1.0.9
	syn@1.0.109
	syn@2.0.119
	syn@3.0.9
	sync_wrapper@1.0.2
	synstructure@0.14.0
	system-deps@6.2.2
	tao-macros@0.1.4
	tao@0.37.1
	target-lexicon@0.12.16
	tauri-build@2.7.3
	tauri-codegen@2.7.3
	tauri-macros@2.7.3
	tauri-plugin-clipboard-manager@2.5.0
	tauri-plugin-notification@2.7.0
	tauri-plugin-single-instance@2.5.4
	tauri-plugin@2.7.2
	tauri-runtime-wry@2.12.2
	tauri-runtime@2.12.2
	tauri-utils@2.10.2
	tauri-winres@0.3.6
	tauri-winrt-notification@0.8.1
	tauri@2.12.4
	tempfile@3.27.0
	tendril@0.5.1
	thiserror-impl@1.0.69
	thiserror-impl@2.0.21
	thiserror@1.0.69
	thiserror@2.0.21
	tiff@0.11.3
	time-core@0.1.9
	time-macros@0.2.32
	time@0.3.55
	tinystr@0.8.4
	tinyvec@1.13.3
	tokio-macros@2.7.2
	tokio-rustls@0.26.6
	tokio-util@0.7.20
	tokio@1.53.3
	toml@0.8.2
	toml@1.1.8+spec-1.1.0
	toml_datetime@0.6.3
	toml_datetime@1.1.2+spec-1.1.0
	toml_edit@0.19.15
	toml_edit@0.20.2
	toml_edit@0.25.17+spec-1.1.0
	toml_parser@1.1.5+spec-1.1.0
	toml_writer@1.1.3+spec-1.1.0
	tower-http@0.6.11
	tower-layer@0.3.3
	tower-service@0.3.3
	tower@0.5.3
	tracing-attributes@0.1.31
	tracing-core@0.1.36
	tracing@0.1.44
	tray-icon@0.25.1
	tree_magic_mini@3.2.2
	try-lock@0.2.5
	typed-path@0.13.0
	typeid@1.0.3
	typenum@1.20.1
	uds_windows@1.2.1
	unicase@2.10.0
	unicode-ident@1.0.27
	unicode-segmentation@1.13.3
	untrusted@0.9.0
	url@2.5.8
	urlencoding@2.1.3
	urlpattern@0.6.0
	utf8_iter@1.0.4
	utf8parse@0.2.2
	uuid@1.28.0
	vcpkg@0.2.15
	version-compare@0.2.1
	version_check@0.9.5
	vswhom-sys@0.1.3
	vswhom@0.1.0
	walkdir@2.5.0
	want@0.3.2
	wasi@0.11.1+wasi-snapshot-preview1
	wasip2@1.0.4+wasi-0.2.12
	wasm-bindgen-futures@0.4.79
	wasm-bindgen-macro-support@0.2.129
	wasm-bindgen-macro@0.2.129
	wasm-bindgen-shared@0.2.129
	wasm-bindgen@0.2.129
	wasm-streams@0.5.0
	wayland-backend@0.3.17
	wayland-client@0.31.15
	wayland-protocols-wlr@0.3.12
	wayland-protocols@0.32.13
	wayland-scanner@0.31.11
	wayland-sys@0.31.11
	web-sys@0.3.106
	web-time@1.1.0
	web_atoms@0.2.6
	webkit2gtk-sys@2.0.2
	webkit2gtk@2.0.2
	webpki-roots@1.0.10
	webview2-com-macros@0.8.1
	webview2-com-sys@0.39.1
	webview2-com@0.39.1
	weezl@0.1.12
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.11
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	window-vibrancy@0.8.1
	windows-collections@0.3.2
	windows-core@0.62.2
	windows-future@0.3.2
	windows-implement@0.60.2
	windows-interface@0.59.3
	windows-link@0.2.1
	windows-numerics@0.3.1
	windows-result@0.4.1
	windows-strings@0.5.1
	windows-sys@0.45.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-sys@0.61.2
	windows-targets@0.42.2
	windows-targets@0.52.6
	windows-threading@0.2.1
	windows-version@0.1.7
	windows@0.62.2
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.52.6
	winnow@0.5.40
	winnow@1.0.4
	winreg@0.56.0
	wit-bindgen@0.57.1
	wl-clipboard-rs@0.9.4
	writeable@0.6.4
	wry@0.57.0
	x11-dl@2.21.0
	x11@2.21.0
	x11rb-protocol@0.13.2
	x11rb@0.13.2
	yoke-derive@0.8.4
	yoke@0.8.3
	zbus@5.19.0
	zbus_macros@5.19.0
	zbus_names@4.3.5
	zcheapstr@1.1.0
	zerocopy-derive@0.8.63
	zerocopy@0.8.63
	zerofrom-derive@0.1.8
	zerofrom@0.1.8
	zeroize@1.9.1
	zerotrie@0.2.5
	zerovec-derive@0.11.6
	zerovec@0.11.8
	zip@9.2.1
	zlib-rs@0.6.8
	zmij@1.0.23
	zopfli@0.8.4
	zune-core@0.5.3
	zune-jpeg@0.5.15
	zvariant@5.15.1
	zvariant_derive@5.15.1
	zvariant_utils@4.2.0
"

inherit cargo desktop xdg

DESCRIPTION="ClamAV Desktop application (GUI) - A modern Linux desktop interface for ClamAV"
HOMEPAGE="https://github.com/linx-systems/clamui https://clamui.com"
SRC_URI="https://github.com/linx-systems/clamui/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0
	CDLA-Permissive-2.0 ISC MIT MPL-2.0 Unicode-3.0 Unlicense ZLIB
"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="network-sandbox"

# Runtime dependencies
RDEPEND="
	>=app-antivirus/clamav-0.103
	>=dev-libs/glib-2.74:2
	>=net-libs/webkit-gtk-2.48.5:4.1
	>=x11-libs/gtk+-3.24:3
	>=gnome-base/librsvg-2.40:2
	>=dev-libs/openssl-3.0:0
	>=sys-auth/polkit-0.100
"

# Build dependencies
BDEPEND="
	${RDEPEND}
	>=dev-lang/rust-${RUST_MIN_VER}
	>=dev-lang/bun-1.0
"

S="${WORKDIR}/${P}"

src_unpack() {
	default
	cargo_crate_unpack
}

src_prepare() {
	default
}

src_compile() {
	# Build frontend dependencies
	cd "${S}/desktop" || die
	bun install --frozen-lockfile || die "Failed to install frontend dependencies"

	# Build frontend
	bun run build || die "Failed to build frontend"

	# Build Rust backend (Tauri application)
	cd "${S}" || die
	cargo build --release --locked || die "Failed to build Tauri backend"

	# Build CLI tools from clamui-core
	cd "${S}/crates/clamui-core" || die
	cargo build --release --locked --bins || die "Failed to build core binaries"
}

src_install() {
	# Install main binary
	newbin "${S}/target/release/clamui" clamui

	# Install CLI tools from clamui-core
	# Cargo in a workspace member directory still outputs to the workspace root target directory,
	# but we check both just in case of local target overrides.
	if [[ -f "${S}/target/release/clamui-cli" ]]; then
		newbin "${S}/target/release/clamui-cli" clamui-cli
		newbin "${S}/target/release/clamui-scheduled-scan" clamui-scheduled-scan
		newbin "${S}/target/release/clamui-apply-preferences" clamui-apply-preferences
	else
		newbin "${S}/crates/clamui-core/target/release/clamui-cli" clamui-cli
		newbin "${S}/crates/clamui-core/target/release/clamui-scheduled-scan" clamui-scheduled-scan
		newbin "${S}/crates/clamui-core/target/release/clamui-apply-preferences" clamui-apply-preferences
	fi

	# Install desktop integration files from data/ directory

	# Install icon
	insinto /usr/share/icons/hicolor/scalable/apps
	newins "${S}/icons/io.github.linx_systems.ClamUI.svg" clamui.svg

	# Install desktop files
	insinto /usr/share/applications
	newins "${S}/data/io.github.linx_systems.ClamUI.desktop" clamui.desktop
	newins "${S}/data/io.github.linx_systems.ClamUI-virustotal.desktop" clamui-virustotal.desktop

	# Install metainfo
	insinto /usr/share/metainfo
	newins "${S}/data/io.github.linx_systems.ClamUI.metainfo.xml" clamui.metainfo.xml

	# Install polkit policy
	insinto /usr/share/polkit-1/actions
	newins "${S}/data/io.github.linx_systems.ClamUI.policy" clamui.policy

	# Install documentation
	DOCS=(
		README.md
		CHANGELOG.md
		LICENSE
	)

	einstalldocs
}

pkg_postinst() {
	elog "ClamUI ${PV} has been installed."
	elog ""
	elog "ClamUI is a modern GUI for ClamAV. To use it, you need to have"
	elog "app-antivirus/clamav installed."
	elog ""
	elog "For full functionality, you may need to install the privileged helper:"
	elog "  sudo clamui install-privileged-helper"
	elog ""
	elog "Optional: Enable scheduled scans with:"
	elog "  systemctl --user enable --now clamui-scheduled-scan.timer"
}
