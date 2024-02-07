#!/bin/bash


curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes.gpg

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/kubernetes.gpg] http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list

sudo apt update

sudo apt-get install -y kubelet kubeadm kubectl

sudo apt-mark hold kubeadm kubelet kubectl

kubeadm version

sudo swapoff -a

sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab


cat << EOF > /etc/modules-load.d/containerd.conf
overlay
br_netfilter

EOF
sleep  3

sudo modprobe overlay

sudo modprobe br_netfilter

cat << EOF > /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1

EOF
sleep 3


sudo hostnamectl set-hostname master-node

exec bash
