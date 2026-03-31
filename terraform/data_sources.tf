#VPC
data "aws_vpc" "kube-vpc" {
    id = "vpc-0e1beec375940a4b3"
}

#PUBLIC & PRIVATE SUBNETS
data "aws_subnet" "kube-vpc-private-subnet" {
    id = "subnet-0ce30b9fdfeca99d0"
}

data "aws_subnet" "kube-vpc-public-subnet" {
    id = "subnet-0fc1ae9f71ba555ad"
}

#SECURITY GROUP
data "aws_security_group" "sg_kube" {
    id = "sg-09f539c20175cdbce"
}

data "aws_nat_gateway" "nat-gw" {
    id = "nat-04f9fb35304d374d1"
}