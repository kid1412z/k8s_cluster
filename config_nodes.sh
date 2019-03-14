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
    sed -i 's/${this_ip}/10.0.0.102/g' /k8s/kubernetes/cfg/kube-proxy
    sed -i 's/${this_ip}/10.0.0.102/g' /k8s/kubernetes/cfg/kubelet
    sed -i 's/${this_ip}/10.0.0.102/g' /k8s/kubernetes/cfg/kubelet.config
elif [[ $1 -eq 3 ]]; then
    sed -i 's/${this_name}/etcd03/g' /k8s/etcd/cfg/etcd.conf
    sed -i 's/${this_ip}/10.0.0.103/g' /k8s/etcd/cfg/etcd.conf
    sed -i 's/${this_ip}/10.0.0.103/g' /k8s/kubernetes/cfg/kube-proxy
    sed -i 's/${this_ip}/10.0.0.103/g' /k8s/kubernetes/cfg/kubelet
    sed -i 's/${this_ip}/10.0.0.103/g' /k8s/kubernetes/cfg/kubelet.config
fi
echo "Install etcd done."

echo "Install docker..."
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum list docker-ce --showduplicates | sort -r
yum install docker-ce -y
rm -f /usr/lib/systemd/system/docker.service
cp /vagrant/systemd/docker.service /usr/lib/systemd/system/docker.service

echo "Install kubelet..."
if [[ ! -f "kubernetes-node-linux-amd64.tar.gz" ]];then
    wget https://dl.k8s.io/v1.13.1/kubernetes-node-linux-amd64.tar.gz
fi
tar zxvf kubernetes-node-linux-amd64.tar.gz
cp kubernetes/node/bin/kube-proxy kubernetes/node/bin/kubelet kubernetes/node/bin/kubectl /k8s/kubernetes/bin/


echo "Install flannel..."
if [[ ! -f "flannel-v0.10.0-linux-amd64.tar.gz" ]]; then
    wget https://github.com/coreos/flannel/releases/download/v0.10.0/flannel-v0.10.0-linux-amd64.tar.gz
fi

tar -xvf flannel-v0.10.0-linux-amd64.tar.gz
mv flanneld mk-docker-opts.sh /k8s/kubernetes/bin/



echo "Config systemd..."
cp /vagrant/systemd/etcd.service /usr/lib/systemd/system/etcd.service
cp /vagrant/systemd/kubelet.service /usr/lib/systemd/system/kubelet.service
cp /vagrant/systemd/kube-proxy.service /usr/lib/systemd/system/kube-proxy.service
cp /vagrant/systemd/flanneld.service /usr/lib/systemd/system/flanneld.service
systemctl daemon-reload
systemctl enable etcd
systemctl enable docker
systemctl enable kubelet
systemctl enable kube-proxy
systemctl enable flanneld

cd /k8s/kubernetes/cfg/
source /etc/profile
sh environment.sh

echo "Starting etcd..."
nohup systemctl start etcd &