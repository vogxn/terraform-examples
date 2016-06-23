variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

variable "amis" {
    description = "bastion node amzn linux with altered sshd_config => GatewayPorts yes"
    default = {
        eu-west-1 = "ami-9a53e3e9"
        us-east-1 = "ami-67311b0d"
        us-west-1 = "ami-f68ff996"
        us-west-2 = "ami-2559b845"
    }
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/24"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/25"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.0.128/25"
}

variable "tunnel_server" {
    description = "Public IP of the Qubole Tunnel Server"
}

variable "s3endpoint" {
    description = "s3 endpoint for instances in private subnets"
    default = {
        eu-west-1 = "com.amazonaws.eu-west-1.s3"
        us-west-1 = "com.amazonaws.us-west-1.s3"
        us-west-2 = "com.amazonaws.us-west-2.s3"
        us-east-1 = "com.amazonaws.us-east-1.s3"
    }
}

variable "deployment_key_name" {
   description = "the name of the key pair that exists in your AWS account. used to launch the bastion node"
}

variable "deployment_pub_key" {
   description = "public key corresponding to your key-pair in your AWS account"
}
