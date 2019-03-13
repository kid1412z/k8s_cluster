#!/bin/bash
cd /vagrant
cp -r k8s /
echo "Install etcd..."
cd /vagrant
if [[ ! -f "etcd-v3.3.10-linux-amd64.tar.gz" ]]; then
    wget https://github.com/etcd-io/etcd/releases/download/v3.3.10/etcd-v3.3.10-linux-amd64.tar.gz
fi
tar -xvf etcd-v3.3.10-linux-amd64.tar.gz
cp etcd-v3.3.10-linux-amd64/etcd etcd-v3.3.10-linux-amd64/etcdctl /k8s/etcd/bin/
mkdir -p /data1/etcd
sed -i 's/${this_name}/etcd01/g' /k8s/etcd/cfg/etcd.conf
sed -i 's/${this_ip}/10.0.0.101/g' /k8s/etcd/cfg/etcd.conf
echo "Install etcd done."

echo "Install kubernetes..."
cd /vagrant
if [[ ! -f kubernetes-server-linux-amd64.tar.gz ]]; then
    wget https://dl.k8s.io/v1.13.1/kubernetes-server-linux-amd64.tar.gz
fi
tar -zxvf kubernetes-server-linux-amd64.tar.gz 
cp kubernetes/server/bin/kube-scheduler kubernetes/server/bin/kube-apiserver kubernetes/server/bin/kube-controller-manager kubernetes/server/bin/kubectl kubernetes/server/bin/kubeadm /k8s/kubernetes/bin/
echo "Install kubernetes done."
echo "PATH=/k8s/kubernetes/bin:/k8s/etcd/bin:$PATH" >> /etc/profile

echo "Config systemd..."
cp /vagrant/systemd/etcd.service /usr/lib/systemd/system/etcd.service
cp /vagrant/systemd/kube-apiserver.service /usr/lib/systemd/system/kube-apiserver.service
cp /vagrant/systemd/kube-controller-manager.service /usr/lib/systemd/system/kube-controller-manager.service
cp /vagrant/systemd/kube-scheduler.service /usr/lib/systemd/system/kube-scheduler.service
systemctl daemon-reload
systemctl enable etcd
systemctl enable kube-apiserver
systemctl enable kube-controller-manager
systemctl enable kube-scheduler
echo "Config systemd done."

echo "Starting etcd..."
nohup systemctl start etcd &

# check etcd status
# /k8s/etcd/bin/etcdctl --cacert=/k8s/etcd/ssl/ca.pem --cert=/k8s/etcd/ssl/server.pem --key=/k8s/etcd/ssl/server-key.pem --endpoints="https://10.0.0.101:2379,https://10.0.0.102:2379,https://10.0.0.103:2379"