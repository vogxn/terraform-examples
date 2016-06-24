resource "aws_vpc" "qubole-vpc-customdns" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags {
        Name = "vpc-qubole-vpc-customdns"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.qubole-vpc-customdns.id}"
}

/*
  Public Subnet
*/
resource "aws_subnet" "vpc-qubole-vpc-customdns-public" {
    vpc_id = "${aws_vpc.qubole-vpc-customdns.id}"
    cidr_block = "${var.public_subnet_cidr}"
    map_public_ip_on_launch = true
    tags {
        Name = "qubole-vpc-customdns-public-subnet"
    }
}

resource "aws_route_table" "vpc-qubole-vpc-customdns-public" {
    vpc_id = "${aws_vpc.qubole-vpc-customdns.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "qubole-vpc-customdns-public-subnet-rtb"
    }
}

resource "aws_route_table_association" "vpc-qubole-vpc-customdns-public" {
    subnet_id = "${aws_subnet.vpc-qubole-vpc-customdns-public.id}"
    route_table_id = "${aws_route_table.vpc-qubole-vpc-customdns-public.id}"
}


/* Security Groups */
