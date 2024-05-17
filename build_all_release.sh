#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)

bash "${SCRIPT_DIR}/build_zlib_release.sh"
bash "${SCRIPT_DIR}/build_protobuf_release.sh"
bash "${SCRIPT_DIR}/build_boost_release.sh"
bash "${SCRIPT_DIR}/build_tcmalloc_release.sh"
