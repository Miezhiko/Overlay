# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.95.0"

CRATES="
	accesskit@0.24.1
	accesskit_atspi_common@0.19.1
	accesskit_consumer@0.38.0
	accesskit_macos@0.26.3
	accesskit_unix@0.22.1
	accesskit_windows@0.34.0
	addr2line@0.27.1
	adler2@2.0.1
	aead@0.5.2
	aes@0.8.4
	ahash@0.8.12
	aho-corasick@1.1.5
	aligned-vec@0.6.4
	aligned@0.4.3
	allocator-api2@0.2.21
	android_system_properties@0.1.6
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	anyhow@1.0.104
	arbitrary@1.5.0
	arg_enum_proc_macro@0.3.4
	arrayref@0.3.9
	arrayvec@0.7.8
	as-raw-xcb-connection@1.0.1
	as-slice@0.2.1
	ash@0.38.0+1.3.281
	ashpd@0.13.13
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
	atomic-waker@1.1.2
	atspi-common@0.13.0
	atspi-proxies@0.13.0
	atspi@0.29.0
	autocfg@1.5.1
	av-scenechange@0.14.1
	av1-grain@0.2.5
	avif-serialize@0.8.9
	backtrace@0.3.77
	base64@0.22.1
	bit-set@0.10.0
	bit-vec@0.9.1
	bit_field@0.10.3
	bitflags@1.3.2
	bitflags@2.13.2
	bitstream-io@4.10.0
	block-buffer@0.10.4
	block-padding@0.3.3
	block2@0.5.1
	block2@0.6.2
	block@0.1.6
	blocking@1.7.0
	built@0.8.1
	bumpalo@3.20.3
	bytemuck@1.25.2
	bytemuck_derive@1.12.1
	byteorder-lite@0.1.0
	byteorder@1.5.0
	bytes@1.12.1
	calloop-wayland-source@0.4.1
	calloop@0.14.5
	cbc@0.1.2
	cbindgen@0.28.0
	cc@1.8.0
	cfg-if@1.0.5
	cfg_aliases@0.2.2
	chacha20@0.9.1
	chacha20poly1305@0.10.1
	chrono@0.4.45
	cipher@0.4.4
	clap@4.6.7
	clap_builder@4.6.7
	clap_complete@4.6.11
	clap_derive@4.6.7
	clap_lex@1.1.1
	cobs@0.3.0
	cocoa-foundation@0.1.2
	cocoa@0.25.0
	codespan-reporting@0.13.1
	color_quant@1.1.0
	colorchoice@1.0.5
	concurrent-queue@2.5.0
	console_error_panic_hook@0.1.7
	const-random-macro@0.1.16
	const-random@0.1.18
	convert_case@0.10.0
	core-foundation-sys@0.8.7
	core-foundation@0.10.0
	core-foundation@0.9.4
	core-graphics-helmer-fork@0.24.0
	core-graphics-types@0.1.3
	core-graphics-types@0.2.0
	core-graphics@0.23.2
	core-graphics@0.24.0
	core-text@21.0.0
	core_detect@1.0.0
	core_maths@0.1.1
	cosmic-text@0.19.0
	cpufeatures@0.2.17
	crc32fast@1.5.2
	crossbeam-deque@0.8.8
	crossbeam-epoch@0.9.21
	crossbeam-utils@0.8.23
	crunchy@0.2.4
	crypto-common@0.1.7
	ctor@1.0.13
	curve25519-dalek-derive@0.1.1
	curve25519-dalek@4.1.3
	data-url@0.3.2
	deranged@0.5.9
	derive_more-impl@2.1.1
	derive_more@2.1.1
	digest@0.10.7
	dirs-sys@0.4.1
	dirs@5.0.1
	dispatch2@0.3.1
	dispatch@0.2.0
	displaydoc@0.2.7
	dlib@0.5.3
	document-features@0.2.12
	downcast-rs@1.2.1
	dunce@1.0.5
	dwrote@0.11.5
	dyn-clone@1.0.20
	either@1.19.0
	embed-resource@3.0.12
	embedded-io@0.4.0
	embedded-io@0.6.1
	encoding_rs@0.8.42
	endi@1.1.1
	enumflags2@0.7.12
	enumflags2_derive@0.7.12
	enumn@0.1.14
	equator-macro@0.4.2
	equator@0.4.2
	equivalent@1.0.2
	errno@0.3.14
	etagere@0.2.15
	euclid@0.22.14
	event-listener-strategy@0.5.4
	event-listener@5.4.2
	exr@1.74.2
	fastrand@2.5.0
	fax@0.2.7
	fdeflate@0.3.7
	fiat-crypto@0.2.9
	filedescriptor@0.8.3
	filetime@0.2.29
	find-msvc-tools@0.1.14
	flate2@1.1.10
	float-cmp@0.9.0
	float-ord@0.3.2
	float_next_after@1.0.0
	flume@0.12.0
	foldhash@0.2.0
	font-types@0.11.3
	font-types@0.12.6
	fontconfig-parser@0.5.8
	fontdb@0.23.0
	foreign-types-macros@0.2.4
	foreign-types-shared@0.3.1
	foreign-types@0.5.0
	form_urlencoded@1.2.2
	freetype-sys@0.20.1
	futures-channel@0.3.34
	futures-core@0.3.34
	futures-executor@0.3.34
	futures-io@0.3.34
	futures-lite@2.6.1
	futures-macro@0.3.34
	futures-sink@0.3.34
	futures-task@0.3.34
	futures-util@0.3.34
	futures@0.3.34
	generic-array@0.14.7
	gethostname@1.1.0
	getrandom@0.2.17
	getrandom@0.3.4
	getrandom@0.4.3
	gif@0.14.2
	gimli@0.34.0
	gl_generator@0.14.0
	glow@0.17.0
	glutin_wgl_sys@0.6.1
	gpu-allocator@0.28.0
	gpui-fast-apple@0.1.12
	gpui-fast-linux@0.1.12
	gpui-fast-macos@0.1.12
	gpui-fast-macros@0.1.12
	gpui-fast-platform@0.1.12
	gpui-fast-web@0.1.12
	gpui-fast-wgpu@0.1.12
	gpui-fast-windows@0.1.12
	gpui-fast@0.1.12
	gpui-pre-apple@0.3.10
	gpui-pre-collections@0.3.10
	gpui-pre-derive-refineable@0.3.10
	gpui-pre-http-client@0.3.10
	gpui-pre-ios@0.3.10
	gpui-pre-macros@0.3.10
	gpui-pre-refineable@0.3.10
	gpui-pre-scheduler@0.3.10
	gpui-pre-shared-string@0.3.10
	gpui-pre-sum-tree@0.3.10
	gpui-pre-util@0.3.10
	gpui-pre-ztracing-macro@0.3.10
	gpui-pre-ztracing@0.3.10
	gpui-pre@0.3.10
	half@2.7.1
	harfrust@0.5.2
	hash32@0.3.1
	hashbrown@0.14.5
	hashbrown@0.16.1
	hashbrown@0.17.1
	heapless@0.9.3
	heck@0.4.1
	heck@0.5.0
	hermit-abi@0.5.3
	hex@0.4.3
	hkdf@0.12.4
	hmac@0.12.1
	http-body@1.1.0
	http@1.5.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.65
	icu_collections@2.3.0
	icu_locale_core@2.3.0
	icu_normalizer@2.3.0
	icu_normalizer_data@2.3.0
	icu_properties@2.3.0
	icu_properties_data@2.3.0
	icu_provider@2.3.1
	idna@1.1.0
	idna_adapter@1.2.2
	if-addrs@0.13.4
	image-webp@0.2.4
	image@0.25.10
	imagesize@0.14.0
	imgref@1.12.3
	indexmap@2.14.2
	inout@0.1.4
	interpolate_name@0.2.4
	inventory@0.3.25
	ipconfig@0.3.4
	is-docker@0.2.0
	is-wsl@0.4.0
	is_terminal_polyfill@1.70.2
	itertools@0.14.0
	itoa@1.0.18
	jni-sys-macros@0.4.1
	jni-sys@0.3.1
	jni-sys@0.4.1
	jobserver@0.1.35
	js-sys@0.3.106
	keyring@3.6.3
	khronos-egl@6.0.0
	khronos_api@3.1.0
	kurbo@0.13.1
	lazy_static@1.5.1
	lebe@0.5.3
	libc@0.2.189
	libfuzzer-sys@0.4.13
	libloading@0.8.9
	libm@0.2.16
	libredox@0.1.25
	linebender_resource_handle@0.1.1
	link-section@0.19.3
	linktime-proc-macro@0.2.3
	linux-raw-sys@0.12.1
	litemap@0.8.3
	litrs@1.0.1
	lock_api@0.4.14
	log@0.4.34
	loop9@0.1.5
	lyon@1.0.19
	lyon_algorithms@1.0.21
	lyon_geom@1.0.19
	lyon_path@1.0.19
	lyon_tessellation@1.0.22
	lz4_flex@0.14.0
	mac-notification-sys@0.6.15
	mach2@0.6.0
	malloc_buf@0.0.6
	maybe-rayon@0.1.1
	md-5@0.10.6
	memchr@2.8.3
	memmap2@0.9.11
	memoffset@0.9.1
	metal@0.33.0
	minisign-verify@0.3.0
	miniz_oxide@0.8.9
	miniz_oxide@0.9.1
	moxcms@0.8.1
	multiversion_no_op@1.0.0
	naga-types@30.0.1
	naga@30.0.1
	ndk-sys@0.6.0+11769913
	new_debug_unreachable@1.0.6
	nix@0.31.3
	no_std_io2@0.9.4
	nom@8.0.0
	noop_proc_macro@0.3.0
	notify-rust@4.18.2
	ntapi@0.4.3
	num-bigint-dig@0.9.1
	num-bigint@0.4.8
	num-complex@0.4.6
	num-conv@0.2.2
	num-derive@0.4.2
	num-integer@0.1.47
	num-iter@0.1.46
	num-rational@0.4.2
	num-traits@0.2.19
	num@0.4.3
	num_cpus@1.17.0
	objc-foundation@0.1.1
	objc-sys@0.3.5
	objc2-app-kit@0.2.2
	objc2-app-kit@0.3.2
	objc2-core-data@0.2.2
	objc2-core-foundation@0.3.2
	objc2-core-graphics@0.3.2
	objc2-core-image@0.2.2
	objc2-core-text@0.3.2
	objc2-core-video@0.3.2
	objc2-encode@4.1.0
	objc2-foundation@0.2.2
	objc2-foundation@0.3.2
	objc2-io-surface@0.3.2
	objc2-metal@0.2.2
	objc2-metal@0.3.2
	objc2-quartz-core@0.2.2
	objc2-quartz-core@0.3.2
	objc2-security@0.3.2
	objc2-ui-kit@0.3.2
	objc2-user-notifications@0.3.2
	objc2@0.5.3
	objc2@0.6.5
	objc@0.2.7
	objc_exception@0.1.2
	objc_id@0.1.1
	object@0.40.0
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	oo7@0.6.0
	opaque-debug@0.3.1
	open@5.4.4
	option-ext@0.2.0
	ordered-float@5.5.1
	ordered-stream@0.2.0
	parking@2.2.1
	parking_lot@0.12.5
	parking_lot_core@0.9.12
	paste@1.0.15
	pastey@0.1.1
	pathfinder_geometry@0.5.1
	pathfinder_simd@0.5.6
	pbkdf2@0.12.2
	percent-encoding@2.3.2
	phf@0.13.1
	phf_generator@0.13.1
	phf_macros@0.13.1
	phf_shared@0.13.1
	pico-args@0.5.0
	pin-project-internal@1.1.13
	pin-project-lite@0.2.17
	pin-project@1.1.13
	piper@0.2.5
	pkg-config@0.3.34
	png@0.17.16
	png@0.18.1
	polling@3.11.0
	pollster@0.4.0
	poly1305@0.8.0
	polycool@0.4.0
	portable-atomic-util@0.2.8
	portable-atomic@1.15.0
	postcard@1.1.3
	potential_utf@0.1.6
	powerfmt@0.2.1
	ppv-lite86@0.2.21
	presser@0.3.1
	proc-macro-crate@3.5.0
	proc-macro2@1.0.107
	profiling-procmacros@1.0.18
	profiling@1.0.18
	pulldown-cmark@0.12.2
	pulp-wasm-simd-flag@0.1.1
	pulp@0.22.3
	pxfm@0.1.30
	qoi@0.4.1
	quick-error@2.0.1
	quick-xml@0.41.0
	quote@1.0.47
	r-efi@5.3.0
	r-efi@6.0.0
	rand@0.8.8
	rand@0.9.5
	rand_chacha@0.3.1
	rand_chacha@0.9.0
	rand_core@0.6.4
	rand_core@0.9.5
	range-alloc@0.1.5
	rangemap@1.8.0
	rav1e@0.8.1
	ravif@0.13.0
	raw-cpuid@11.6.0
	raw-window-handle@0.6.2
	raw-window-metal@1.1.0
	rayon-core@1.13.0
	rayon@1.12.0
	read-fonts@0.37.0
	read-fonts@0.41.0
	reborrow@0.5.5
	redox_syscall@0.5.18
	redox_users@0.4.6
	ref-cast-impl@1.0.27
	ref-cast@1.0.27
	regex-automata@0.4.18
	regex-syntax@0.8.11
	regex@1.13.1
	renderdoc-sys@1.1.0
	resvg@0.46.0
	rgb@0.8.53
	ring@0.17.14
	roxmltree@0.20.0
	roxmltree@0.21.2
	rustc-demangle@0.1.28
	rustc-hash@1.1.0
	rustc-hash@2.1.3
	rustc_version@0.4.1
	rustix@1.1.5
	rustls-pki-types@1.15.1
	rustls-webpki@0.103.16
	rustls@0.23.45
	rustversion@1.0.23
	rustybuzz@0.20.1
	ruzstd@0.9.1
	ryu@1.0.23
	same-file@1.0.6
	schemars@1.2.3
	schemars_derive@1.2.3
	scoped-tls@1.0.1
	scopeguard@1.2.0
	screencapturekit-sys@0.2.8
	screencapturekit@0.2.8
	seahash@4.1.0
	security-framework-sys@2.17.0
	security-framework@2.11.1
	security-framework@3.7.0
	self_cell@1.3.0
	semver@1.0.28
	serde@1.0.229
	serde_bytes@0.11.19
	serde_core@1.0.229
	serde_derive@1.0.229
	serde_derive_internals@0.30.0
	serde_json@1.0.154
	serde_repr@0.1.21
	serde_spanned@0.6.9
	serde_spanned@1.1.2
	serde_urlencoded@0.7.1
	sha1@0.10.7
	sha1_smol@1.0.1
	sha2@0.10.9
	shlex@2.0.1
	signal-hook-registry@1.4.8
	simd-adler32@0.3.10
	simd_helpers@0.1.0
	simdutf8@0.1.5
	simplecss@0.2.2
	siphasher@1.0.4
	skrifa@0.40.0
	skrifa@0.44.0
	slab@0.4.12
	slotmap@1.1.1
	smallvec@1.16.3
	smol@2.0.2
	smol_str@0.3.7
	socket2@0.5.10
	socket2@0.6.5
	spake2@0.4.0
	spin@0.10.1
	spin@0.9.9
	spirv@0.4.0+sdk-1.4.341.0
	stable_deref_trait@1.2.1
	static_assertions@1.1.0
	strict-num@0.1.1
	strsim@0.11.1
	strum@0.28.0
	strum_macros@0.28.0
	subtle@2.6.1
	svg_fmt@0.4.5
	svgtypes@0.16.1
	swash@0.2.10
	syn@2.0.119
	syn@3.0.9
	synstructure@0.14.0
	sys-locale@0.3.2
	sysinfo@0.31.4
	taffy@0.15.0
	tao-core-video-sys@0.2.0
	tar@0.4.46
	tauri-winrt-notification@0.8.1
	tempfile@3.27.0
	termcolor@1.4.1
	thiserror-impl@1.0.69
	thiserror-impl@2.0.21
	thiserror@1.0.69
	thiserror@2.0.21
	tiff@0.11.3
	time-core@0.1.9
	time@0.3.55
	tiny-keccak@2.0.2
	tiny-skia-path@0.11.4
	tiny-skia@0.11.4
	tinystr@0.8.4
	tinyvec@1.13.3
	tokio@1.53.2
	toml@0.8.23
	toml@1.1.8+spec-1.1.0
	toml_datetime@0.6.11
	toml_datetime@1.1.2+spec-1.1.0
	toml_edit@0.22.27
	toml_edit@0.25.17+spec-1.1.0
	toml_parser@1.1.5+spec-1.1.0
	toml_write@0.1.2
	toml_writer@1.1.3+spec-1.1.0
	tracing-attributes@0.1.31
	tracing-core@0.1.36
	tracing@0.1.44
	trash@5.2.9
	ttf-parser@0.25.1
	twox-hash@2.1.5
	typed-path@0.13.0
	typenum@1.20.1
	uds_windows@1.2.1
	unicase@2.10.0
	unicode-bidi-mirroring@0.4.0
	unicode-bidi@0.3.18
	unicode-ccc@0.4.0
	unicode-ident@1.0.27
	unicode-linebreak@0.1.5
	unicode-properties@0.1.3
	unicode-script@0.5.8
	unicode-segmentation@1.13.3
	unicode-vo@0.1.0
	unicode-width@0.2.2
	universal-hash@0.5.1
	untrusted@0.9.0
	ureq@2.12.1
	url@2.5.8
	urlencoding@2.1.3
	usvg@0.46.0
	utf8_iter@1.0.4
	utf8parse@0.2.2
	uuid@1.28.0
	v_frame@0.3.9
	version_check@0.9.5
	vswhom-sys@0.1.3
	vswhom@0.1.0
	waker-fn@1.2.0
	walkdir@2.5.0
	wasi@0.11.1+wasi-snapshot-preview1
	wasip2@1.0.4+wasi-0.2.12
	wasm-bindgen-futures@0.4.79
	wasm-bindgen-macro-support@0.2.129
	wasm-bindgen-macro@0.2.129
	wasm-bindgen-shared@0.2.129
	wasm-bindgen@0.2.129
	wasm_thread@0.3.3
	wasmparser@0.254.2
	wayland-backend@0.3.17
	wayland-client@0.31.15
	wayland-cursor@0.31.14
	wayland-protocols-plasma@0.3.12
	wayland-protocols-wlr@0.3.12
	wayland-protocols@0.32.13
	wayland-scanner@0.31.11
	wayland-sys@0.31.11
	web-sys@0.3.106
	web-time@1.1.0
	webpki-roots@0.26.11
	webpki-roots@1.0.10
	weezl@0.1.12
	wgpu-core-deps-apple@30.0.1
	wgpu-core-deps-emscripten@30.0.1
	wgpu-core-deps-wasm@30.0.1
	wgpu-core-deps-windows-linux-android@30.0.1
	wgpu-core@30.0.1
	wgpu-hal@30.0.1
	wgpu-naga-bridge@30.0.1
	wgpu-types@30.0.1
	wgpu@30.0.1
	which@8.0.6
	widestring@1.2.1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.11
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-capture@1.5.0
	windows-collections@0.2.0
	windows-collections@0.3.2
	windows-core@0.57.0
	windows-core@0.61.2
	windows-core@0.62.2
	windows-future@0.2.1
	windows-future@0.3.2
	windows-implement@0.57.0
	windows-implement@0.60.2
	windows-interface@0.57.0
	windows-interface@0.59.3
	windows-link@0.1.3
	windows-link@0.2.1
	windows-numerics@0.2.0
	windows-numerics@0.3.1
	windows-registry@0.6.1
	windows-result@0.1.2
	windows-result@0.3.4
	windows-result@0.4.1
	windows-strings@0.4.2
	windows-strings@0.5.1
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows-targets@0.53.5
	windows-threading@0.1.0
	windows-threading@0.2.1
	windows-version@0.1.7
	windows@0.57.0
	windows@0.61.3
	windows@0.62.2
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.52.6
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
	windows_x86_64_msvc@0.53.1
	winnow@0.7.15
	winnow@1.0.4
	winreg@0.56.0
	winresource@0.1.34
	wio@0.2.2
	wit-bindgen@0.57.1
	writeable@0.6.4
	x11@2.21.0
	x11rb-protocol@0.13.2
	x11rb@0.13.2
	xcb@1.7.1
	xcursor@0.3.11
	xim-ctext@0.3.0
	xim-parser@0.2.2
	xkbcommon@0.8.0
	xkeysym@0.2.1
	xml-rs@0.8.29
	xmlwriter@0.1.0
	xxhash-rust@0.8.19
	y4m@0.8.0
	yazi@0.2.1
	yeslogic-fontconfig-sys@6.0.1
	yoke-derive@0.8.4
	yoke@0.8.3
	zbus-lockstep-macros@0.5.2
	zbus-lockstep@0.5.2
	zbus@5.19.0
	zbus_macros@5.19.0
	zbus_names@4.3.4
	zbus_xml@5.2.1
	zcheapstr@1.1.0
	zed-font-kit@0.14.1-zed
	zed-scap@0.0.8-zed
	zed-xim@0.4.0-zed
	zeno@0.3.3
	zerocopy-derive@0.8.62
	zerocopy@0.8.62
	zerofrom-derive@0.1.8
	zerofrom@0.1.8
	zeroize@1.9.1
	zeroize_derive@1.5.0
	zerotrie@0.2.5
	zerovec-derive@0.11.6
	zerovec@0.11.8
	zip@9.2.0
	zlib-rs@0.6.8
	zmij@1.0.23
	zopfli@0.8.4
	zune-core@0.5.3
	zune-inflate@0.2.54
	zune-jpeg@0.5.15
	zvariant@5.15.0
	zvariant_derive@5.15.0
	zvariant_utils@4.2.0
"

inherit cargo xdg

DESCRIPTION="Desktop launcher for Horizon, a Rust reimplementation of Minecraft Java Edition"
HOMEPAGE="https://github.com/horizon-rust/horizon"

SRC_URI="
	https://github.com/horizon-rust/horizon/archive/refs/tags/launcher@${PV}.zip
	${CARGO_CRATE_URIS}
"

S="${WORKDIR}/horizon-src/launcher"

LICENSE="MIT OFL-1.1"

# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD-2 BSD Boost-1.0 CC0-1.0 CDLA-Permissive-2.0 ISC MIT
	MPL-2.0 UoI-NCSA Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="~amd64"
IUSE="X wayland"

REQUIRED_USE="|| ( X wayland )"

RDEPEND="
	sys-apps/dbus
	media-libs/fontconfig
	media-libs/freetype
	media-libs/vulkan-loader
	virtual/opengl
	x11-libs/libxkbcommon
	X? (
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXi
		x11-libs/libXrandr
		x11-libs/libxcb
	)
	wayland? (
		dev-libs/wayland
	)
"

DEPEND="
	${RDEPEND}
	wayland? (
		dev-libs/wayland-protocols
	)
"

BDEPEND="
	dev-util/pkgconf
	dev-util/vulkan-headers
"

src_unpack() {
	cargo_src_unpack

	local launcher_manifest repo_root

	launcher_manifest=$(find "${WORKDIR}" -type f \
		-path '*/launcher/Cargo.toml' -print -quit)

	[[ -n ${launcher_manifest} ]] ||
		die "Could not locate launcher/Cargo.toml in source archive"

	repo_root=${launcher_manifest%/launcher/Cargo.toml}

	# Remove only the empty directories created for S.
	rmdir "${S}" "${WORKDIR}/horizon-src" ||
		die "Could not remove pre-created source directories"

	mv "${repo_root}" "${WORKDIR}/horizon-src" ||
		die "Could not normalize source directory"

	[[ -f "${S}/Cargo.toml" ]] ||
		die "Launcher Cargo.toml missing after source normalization"
}

src_prepare() {
	default

	grep -Fq 'features = ["wayland", "x11", "font-kit"]' Cargo.toml ||
		die "Unexpected gpui-fast-platform feature declaration"

	sed -i \
		-e 's/features = \["wayland", "x11", "font-kit"\]/features = ["font-kit"]/' \
		Cargo.toml || die
}

src_configure() {
	local myfeatures=(
		$(usev X gpui_platform/x11)
		$(usev wayland gpui_platform/wayland)
	)

	cargo_src_configure
}

src_compile() {
	export HORIZON_MSA_CLIENT_ID="331e08f8-172d-43b9-835a-3108c2fcdbf3"
	export HORIZON_LAUNCHER_VERSION="${PV}"
	export HORIZON_LAUNCHER_TAG="launcher@${PV}"

	cargo_src_compile
}

src_install() {
	exeinto "/usr/libexec/${PN}"
	doexe "$(cargo_target_dir)/horizon-launcher"

	printf '%s\n' \
		'#!/bin/sh' \
		'export HORIZON_LAUNCHER_NO_SELF_UPDATE=1' \
		'export HORIZON_LAUNCHER_DESKTOP_EXEC="/usr/bin/horizon-launcher"' \
		'exec /usr/libexec/horizon-launcher/horizon-launcher "$@"' \
		> "${T}/horizon-launcher" || die

	dobin "${T}/horizon-launcher"

	if [[ -d "${WORKDIR}/horizon-src/packaging/icons/hicolor" ]]; then
		insinto /usr/share/icons/hicolor
		doins -r "${WORKDIR}/horizon-src/packaging/icons/hicolor/"*
	fi

	mkdir -p \
		"${T}/launcher-home" \
		"${ED}/usr/share/applications" || die

	HOME="${T}/launcher-home" \
	XDG_DATA_HOME="${ED}/usr/share" \
	HORIZON_LAUNCHER_DESKTOP_EXEC="/usr/bin/horizon-launcher" \
	HORIZON_LAUNCHER_NO_SELF_UPDATE=1 \
		"$(cargo_target_dir)/horizon-launcher" desktop-entry ||
		die "Failed to generate Horizon desktop entry"

	if ! find "${ED}/usr/share/applications" \
		-maxdepth 1 -type f -name '*.desktop' -print -quit |
		grep -q .; then
		die "Horizon desktop entry was not generated"
	fi

	dodoc README.md
}

pkg_postinst() {
	xdg_icon_cache_update

	elog "Horizon will install Minecraft 26.3 when clicking the play button, once you are signed in to a Microsoft account via the launcher."
	elog "Assets can also be imported from another client's install instead (Horizon will look in $XDG_CONFIG_HOME/.minecraft by default) by using the command:" 
	elog "  horizon-launcher prepare"
	elog "Owning Minecraft: Java Edition on a Microsoft account is required regardless."
}

pkg_postrm() {
    xdg_icon_cache_update
}
