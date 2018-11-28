# electron_build_tools ELECTRON-v4.0.0-nightly.20181010 & Chromium-69.0.3497.106

##### v0.02 - added patch for:
`third_party/blink/renderer/core/css/css_property_id_templates.h:19:8: error: explicit specialization of 'WTF::HashTraits<blink::CSSPropertyID>' after instantiation`

##### v0.01 - download chromium with depth=1 and next download electron sources from .gclient-electron - you can save download transfer

##### To run:
`bash sync.sh`

This will download chromium as `src` directory to CWD. Next it runs electron sources download into src/electron.

To build debug run:
```bash
./src/$ ./gn_electron_debug.sh
./src/$ ninja -C out electron
```

Release:
```bash
./src/$ ./gn_electron_release.sh
./src/$ ninja -C out electron
```

Above commands use ccache wrapper - https://github.com/ccache/ccache
