function rpl {
    # Edit this to match installation.
    BINDIR="$HOME/bin/mi"
    DIR="`$BINDIR/rpl \"$@\"`" &&
    echo "dir '$DIR'" >&2 &&
    pushd $DIR &&
    if [ -f src/main.rs ]
    then
        emacs -nw +2 src/main.rs
    elif [ -f src/lib.rs ]
    then
        emacs -nw src/lib.rs
    else
        emacs -nw *.rs
    fi
}
