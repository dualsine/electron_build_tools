# electron_build_tools ELECTRON-v4.0.0-nightly.20181010 & Chromium-69.0.3497.106

##### 0.02 added patch for:
third_party/blink/renderer/core/css/css_property_id_templates.h:19:8: error: explicit specialization of 'WTF::HashTraits<blink::CSSPropertyID>' after instantiation

##### 0.01 download chromium with depth=1 and next download electron sources from .gclient-electron - you can save about 10 gb of download transfer

##### To run:
`bash sync.sh`

This will download chromium as `src` directory to CWD. Next it runs electron sources download into src/electron.     

To build debug run:    
```bash
export CCACHE_CPP2=yes    
export CCACHE_SLOPPINESS=time_macros     
unset CCACHE_HASHDIR    
     
gn gen out --args="import(\"//electron/build/args/debug.gn\") cc_wrapper=\"ccache\" use_custom_libcxx=false is_clang=false use_sysroot=false treat_warnings_as_errors=false"
```
 in src.      
Release:    
```bash
export CCACHE_CPP2=yes     
export CCACHE_SLOPPINESS=time_macros     
unset CCACHE_HASHDIR      
      
gn gen out --args="import(\"//electron/build/args/release.gn\") cc_wrapper=\"ccache\" use_custom_libcxx=false is_clang=false use_sysroot=false treat_warnings_as_errors=false use_jumbo_build=true"   
```

Above commands use ccache - https://github.com/ccache/ccache
