#!/bin/bash

set -x

stderr=$(mktemp)
stdout=$(mktemp)

# keep it classy
rm_tmp() { rm -f "$stderr" "$stdout"; }
trap rm_tmp EXIT

# unit under test
../cargo ubuntu:14.04 . > "$stdout" 2> "$stderr"
retval=$?

if [ $retval -ne 0 ]; then
    echo :: cargo returned failure
    exit 1
fi

# seq 1000000 | sha1sum
if [ "$(sha1sum $stdout | cut -f1 -d ' ')" != "2dcc06b7ca3b7dd8b5626af83c1be3cb08ddc76c" ]; then
    echo :: cargo stdout failure
    exit 1
fi

# seq 20000 | sha1sum
if [ "$(sha1sum $stderr | cut -f1 -d ' ')" != "49972ff155d0d5fb6bb9d8f18a7a4c4a2ea9562c" ]; then
    echo :: cargo stderr failure
    exit 1
fi

# grep RELEASE /etc/lsb-release  | sha1sum
# Output: "DISTRIB_RELEASE=14.04" + \n
if [ "$(sha1sum out/distrib_rel | cut -f1 -d ' ')" != "75c972e6ac64a44008459a3c0b000eda32c30caa" ]; then
    echo :: cargo output file failure
    exit 1
fi

