#!/bin/bash

if [ `hostname` == "node1" ];then
    echo "Register network config"
    /k8s/etcd/bin/etcdctl --ca-file=/k8s/etcd/ssl/ca.pem --cert-file=/k8s/etcd/ssl/server.pem --key-file=/k8s/etcd/ssl/server-key.pem --endpoints="https://10.0.0.101:2379,https://10.0.0.102:2379,https://10.0.0.103:2379"  set /k8s/network/config  '{ "Network": "10.254.0.0/16", "Backend": {"Type": "vxlan"}}'
    echo "Starting kubernetes..."
    systemctl start kube-apiserver
    systemctl start kube-controller-manager
    systemctl start kube-scheduler
    sleep 5
    /k8s/kubernetes/bin/kubectl create clusterrolebinding kubelet-bootstrap \
        --clusterrole=system:node-bootstrapper \
        --user=kubelet-bootstrap
    source /etc/profile
    kubectl get cs,nodes
else
    echo "Starting flanneld..."
    systemctl start flanneld
    echo "Starting docker..."
    systemctl start docker
    echo "Starting kubelet..."
    systemctl start kubelet
    echo "Starting kubeproxy..."
    systemctl start kube-proxy
fi

