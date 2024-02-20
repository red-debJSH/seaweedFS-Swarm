#!/bin/sh

weed volume \
	-mserver=seaweedfs_master:9333 \
	-max=0 \
	-dir=/data \
	-dataCenter="$HOST" 