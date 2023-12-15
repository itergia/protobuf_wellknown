#!/bin/sh

set -e
#set -o pipefail

exec dart pub global run protoc_plugin "$@"
