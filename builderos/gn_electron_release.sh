#!/bin/sh

export CCACHE_CPP2=yes
export CCACHE_SLOPPINESS=time_macros
unset CCACHE_HASHDIR

gn gen out --args="import(\"//electron/build/args/release.gn\") cc_wrapper=\"ccache\" use_jumbo_build=true jumbo_file_merge_limit=5"
