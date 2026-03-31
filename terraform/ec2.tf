resource "aws_instance" "control-plane" {
ami           = "ami-0f9c27b471bdcd702"    # Substitua pelo AMI ID desejado/compatível na sua região
instance_type = "t3.small"
subnet_id     = data.aws_subnet.kube-vpc-public-subnet.id
private_ip    = "10.0.10.10"
key_name      = "kubernetes"
associate_public_ip_address = true
availability_zone = "us-east-1a"
enable_primary_ipv6 = "false"
security_groups = [data.aws_security_group.sg_kube.id]
}

# Se precisar referenciar uma AMI diferente, ajuste a linha 'ami' no recurso acima.
# tags = {
#     Name = "master"
#     }
# }

# resource "aws_instance" "worker1" {
# ami           = "ami-0c55b159cbfafe1f0"    # Substitua pelo AMI ID desejado/compatível na sua região
# instance_type = "t2.micro"
# tags = {
#     Name = "worker1"
#     }
# }

# resource "aws_instance" "worker2" {
# ami           = "ami-0c55b159cbfafe1f0"    # Substitua pelo AMI ID desejado/compatível na sua região
# instance_type = "t2.micro"
# tags = {
#     Name = "worker2"
    
#     }
# }