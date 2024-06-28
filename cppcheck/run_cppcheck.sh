#!/usr/bin/env bash
# Usage: run_cppcheck <CPPCHECK_BINARY> <CPPCHECK_FLAGS_FILE> <FILES...>
set -ue

CPPCHECK_BIN=$1
shift

CPPCHECK_FLAGS_FILE=$1
shift
flags=`cat ${CPPCHECK_FLAGS_FILE}`

"${CPPCHECK_BIN}" ${flags} "$@"

