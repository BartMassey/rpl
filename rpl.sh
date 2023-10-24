#!/bin/sh
# Local "Rust Playground"
# Bart Massey 2021
# Requires `cargo-add` and something like the shell function
# `rpl` available at https://github.com/BartMassey/rpl/rpl-fn.bash .

USAGE="usage: rpl <--bin|--lib> <crate-name> [<dep-crate> ...]"
if [ $# -eq 0 ]
then
    echo "$USAGE" >&2
    exit 1
fi
CRATE_TYPE=""
MINI=true
while [ $# -gt 1 ]
do
    case "$1" in
        "--lib"|"--bin") CRATE_TYPE="$1"; shift ;;
        "--mini") MINI=true; shift ;;
        "--std") MINI=false; shift ;;
        "-*") echo "$USAGE" >&2; exit 1;;
        *) break ;;
    esac
done
if [ "$CRATE_TYPE" = "" ]
then
    echo "must specify crate type" >&2
    exit 1
fi
CRATE_NAME="$1"; shift
if $MINI && [ "$CRATE_TYPE" = "--lib" ]
then
    CRATE_NAME="`echo \"$CRATE_NAME\" | tr '-' '_'`"
fi
CRATE_DIR="$HOME/.rpl/$CRATE_NAME"
if [ -s "$CRATE_DIR/Cargo.toml" ]
then
    echo "$CRATE_DIR"
    exit 0
fi
mkdir -p "$CRATE_DIR" &&
cd "$CRATE_DIR" &&
if $MINI
then
    case "$CRATE_TYPE" in
        "--lib"|"--bin") touch "$CRATE_NAME".rs ;;
        *) echo "unknown crate type $CRATE_TYPE" >&2; exit 1 ;;
    esac
fi &&
cargo init -q --vcs=none "$CRATE_TYPE" &&
for DEP in "$@"
do
    cargo add -q "$DEP"
    if [ $? -ne 0 ]
    then
        exit 1
    fi
done &&
echo "$CRATE_DIR"
