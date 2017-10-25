#!/bin/bash

SUCCESS=0
FAIL=1

PROJ_NAME="wantalk-server"
SRC_DIR="."
DIST_DIR="$SRC_DIR/../dist"

function clean() {
    [ ! -e "$DIST_DIR" ] && mkdir "$DIST_DIR"
    find "$DIST_DIR" -maxdepth 1 -print | \
        grep -E "$DIST_DIR/.+" | \
        xargs -I{} rm -rf {}
}

function build() {
    tsc -p "." --outDir "$DIST_DIR" --sourcemap
}

function test_build() {
    build

    cp "package.json" "$DIST_DIR"
    rsync -a "node_modules" "$DIST_DIR/"
}

function clean_build() {
    clean
    build

    cp "package.json" "$DIST_DIR"
    cd "$DIST_DIR" && npm install
}

function run_docker() {
    cd "./tool/docker"
    ./run.sh
}

function build_typedoc {
    typedoc --name "$PROJ_NAME" --mode "file" --out "../document/typedoc" "$SRC_DIR"
}

$1
exit "$SUCCESS"
