#!/bin/bash
cp -r /vagrant/k8s/ /
echo "Install etcd..."
cd /vagrant
if [[ ! -f "etcd-v3.3.10-linux-amd64.tar.gz" ]]; then
    wget https://github.com/etcd-io/etcd/releases/download/v3.3.10/etcd-v3.3.10-linux-amd64.tar.gz
fi
tar -xvf etcd-v3.3.10-linux-amd64.tar.gz
cp etcd-v3.3.10-linux-amd64/etcd etcd-v3.3.10-linux-amd64/etcdctl /k8s/etcd/bin/
mkdir -p /data1/etcd
if [[ $1 -eq 2 ]]; then
    sed -i 's/${this_name}/etcd02/g' /k8s/etcd/cfg/etcd.conf
    sed -i 's/${this_ip}/10.0.0.102/g' /k8s/etcd/cfg/etcd.conf
elif [[ $1 -eq 3 ]]; then
    sed -i 's/${this_name}/etcd03/g' /k8s/etcd/cfg/etcd.conf
    sed -i 's/${this_ip}/10.0.0.103/g' /k8s/etcd/cfg/etcd.conf
fi
echo "Install etcd done."

echo "Config systemd..."
cp /vagrant/systemd/etcd.service /usr/lib/systemd/system/etcd.service
systemctl daemon-reload
systemctl enable etcd
echo "Starting etcd..."
nohup systemctl start etcd &


