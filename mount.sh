#!/bin/sh

cch=/mnt/cch
mnt=/mnt/cld
cnt_name=seaweedfs_mount_"$HOST"
filer=seaweedfs_filer:8888

trap 'cleanup' INT TERM

cleanup() {
	if [ -n "$mount_proc" ]; then
		kill -TERM "$mount_proc"
	else
		docker stop "$cnt_name" > /dev/null 2>&1
		sleep 5
	fi

	if mountpoint -q "$mnt"; then
		umount -f "$mnt" > /dev/null 2>&1
		while mountpoint -q "$mnt"; do
			sleep 5
		done
	fi
}

cleanup
docker run \
	--rm \
	--name="$cnt_name" \
	--net=seaweedfs \
	--cap-add SYS_ADMIN \
	--security-opt apparmor:unconfined \
	--device /dev/fuse \
	-v /mnt/seaweedfs:/mnt:rshared \
	chrislusf/seaweedfs \
		mount \
		-dir="$mnt" \
		-cacheDir="$cch" \
		-cacheCapacityMB=15000 \
		-dirAutoCreate \
		-map.uid="1000:0" \
		-map.gid="1000:0" \
		-allowOthers=true \
		-filer="$filer" \
		-filer.path=/cld/ &

mount_proc=$!
wait "$mount_proc"