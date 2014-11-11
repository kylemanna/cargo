#!/bin/bash
seq -s " " 1000000
seq -s " " 20000 >&2

mkdir -p /cargo/out
grep RELEASE /etc/lsb-release > /cargo/out/distrib_rel
