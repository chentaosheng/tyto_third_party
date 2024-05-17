#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)

bash "${SCRIPT_DIR}/build_zlib_debug.sh"
bash "${SCRIPT_DIR}/build_protobuf_debug.sh"
bash "${SCRIPT_DIR}/build_boost_debug.sh"
bash "${SCRIPT_DIR}/build_tcmalloc_debug.sh"
