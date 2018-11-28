#!/bin/sh

export CCACHE_CPP2=yes
export CCACHE_SLOPPINESS=time_macros
unset CCACHE_HASHDIR

gn gen out --args="import(\"//electron/build/args/debug.gn\") cc_wrapper=\"ccache\" use_custom_libcxx=false is_clang=false use_sysroot=false treat_warnings_as_errors=false"
