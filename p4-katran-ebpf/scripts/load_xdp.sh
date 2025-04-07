#!/bin/bash
# here we Loading the eBPF program via XDP

set -e

INTERFACE=${1:-eth0}
BPF_OBJ="src/katran.o"

if [ ! -f "$BPF_OBJ" ]; then
    echo "Error: Compiled eBPF object not found at $BPF_OBJ"
    echo "Run ./scripts/build.sh first"
    exit 1
fi

# Load XDP program
sudo ip link set dev $INTERFACE xdp obj $BPF_OBJ sec prog

echo "XDP program loaded on $INTERFACE"
