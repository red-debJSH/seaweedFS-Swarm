#!/bin/sh

# prefer writing to volume server on the same node
volume_hosts="MASTER-SWARM NODE1-SWARM NODE3-SWARM"
if [ "${volume_hosts#*"$HOST"}" != "$volume_hosts" ]; then
	dc=$HOST
else
	dc=NODE1-SWARM # default value if no volume server exists on the same node
fi

cat > /etc/seaweedfs/filer.toml <<- EOF
	[leveldb3]
	enabled = true
	dir = "/data/filerdb"
EOF

weed filer \
	-master=seaweedfs_master:9333 \
	-ip.bind=0.0.0.0 \
	-ip=seaweedfs_filer_"$HOST" \
	-dataCenter="$dc"