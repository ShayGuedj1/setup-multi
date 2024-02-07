#!/bin/bash

cat << EOF > /etc/default/kubelet
KUBELET_EXTRA_ARGS="--cgroup-driver=cgroupfs"
EOF
sleep 3

sudo systemctl daemon-reload && sudo systemctl restart kubelet

cat << EOF > /etc/docker/daemon.json
{
      "exec-opts": ["native.cgroupdriver=systemd"],
      "log-driver": "json-file",
      "log-opts": {
      "max-size": "100m"
   },
       "storage-driver": "overlay2"
       }
EOF 
sleep 3

sudo systemctl daemon-reload && sudo systemctl restart docker

cat << EOF > /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"
EOF
sleep 3

sudo systemctl daemon-reload && sudo systemctl restart kubelet

kubeadm init  --node-name master-node

https://docs.tigera.io/calico/3.25/getting-started/kubernetes/quickstart

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/tigera-operator.yaml

wget https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/custom-resources.yaml

kubectl apply -f custom-resources.yaml

echo "Exit the root user and run the script 'kube-final'."
