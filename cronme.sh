#!/bin/bash
DIR1="/sniff/`date +%Y`/`date +%h`/`date +%d`"
SUBDIR=`cat /tmp/sniffnlog_protocol_enabled | tr ',' ' '`

for proto in $SUBDIR; do
	if [ ! -d "$DIR1/$proto" ]; then mkdir -p "$DIR1/$proto"; fi
done
