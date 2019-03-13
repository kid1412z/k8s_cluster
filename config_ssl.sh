#!/bin/bash
cp -r /vagrant/k8s/ /

# install cfssl
echo "Install cfssl..."
if [[ ! -f "cfssl_linux-amd64" ]]; then
    echo "Download cfssl_linux-amd64"
    wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
fi

if [[ ! -f "cfssljson_linux-amd64" ]]; then
    echo "Download cfssljson_linux-amd64"
    wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
fi

if [[ ! -f "cfssl-certinfo_linux-amd64" ]]; then
    echo "Download cfssl-certinfo_linux-amd64"
    wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64
fi

chmod +x cfssl_linux-amd64 cfssljson_linux-amd64 cfssl-certinfo_linux-amd64
mv cfssl_linux-amd64 /usr/local/bin/cfssl
ln -s /usr/local/bin/cfssl /usr/sbin/cfssl

mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
ln -s /usr/local/bin/cfssljson /usr/sbin/cfssljson

mv cfssl-certinfo_linux-amd64 /usr/bin/cfssl-certinfo
ln -s /usr/local/bin/cfssl-certinfo /usr/sbin/cfssl-certinfo

echo "Install cfssl done."

# config CA
cp -r /vagrant/k8s/ /

echo "Start to config etcd CA..."
cd /k8s/etcd/ssl/
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=etcd server-csr.json | cfssljson -bare server
echo "Config etcd CA done."

# Config Kubernetes
cd /k8s/kubernetes/ssl
echo "Config Kubernetes CA..."

cfssl gencert -initca ca-csr.json | cfssljson -bare ca -
echo "Config Kubernetes CA done."

echo "Config apiserver CA..."
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes server-csr.json | cfssljson -bare server
echo "Config apiserver CA done."

echo "Config kube-proxy CA"
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kube-proxy-csr.json | cfssljson -bare kube-proxy
echo "Config kube-proxy CA done."

echo "Generate token..."
token=$(head -c 16 /dev/urandom | od -An -t x | tr -d ' ')
echo "$token,kubelet-bootstrap,10001,\"system:kubelet-bootstrap\""| tee /k8s/kubernetes/cfg/token.csv