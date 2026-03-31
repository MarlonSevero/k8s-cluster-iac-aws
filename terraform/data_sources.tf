#MAIN VPC
data "aws_vpc" "kube-vpc" {
    id = "vpc-0e1beec375940a4b3"
}

//PRIVATE SUBNET - NODE 1 E NODE 2
data "aws_subnet" "kube-vpc-private-subnet" {
    id = "subnet-0ce30b9fdfeca99d0"
}

//PUBLIC SUBNET  - CONTROL PLANE
data "aws_subnet" "kube-vpc-public-subnet" {
    id = "subnet-0fc1ae9f71ba555ad"
}

//NAT GATEWAY PARA PRIVATE SUBNET SAIR PARA FORA MASQ
data "aws_nat_gateway" "nat-gw" {
    id = "nat-04f9fb35304d374d1"
}

# SECURITY GROUP INFORMATION
# The following ports are used for Kubernetes & related components and should be allowed as needed:
# 6443    - Kubernetes API server
# 2379-2380 - etcd server client API
# 10250   - Kubelet API
# 10259   - kube-scheduler
# 10257   - kube-controller-manager
# 4466    - headlamp (K8s dashboard)
# 6783    - CNI Weave Net
# 80      - LAB (HTTP)
# 8080    - LAB (Alternate HTTP)
# 443     - HTTPS (Kubernetes Dashboard, API server, etc.)
# 22      - SSH ACCESS

data "aws_security_group" "sg_kube" {
    id = "sg-09f539c20175cdbce"
}