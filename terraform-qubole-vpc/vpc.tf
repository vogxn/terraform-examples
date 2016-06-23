resource "aws_key_pair" "deployment-key" {
  key_name = "${var.deployment_key_name}"
  public_key = "${var.deployment_pub_key}"
}

resource "aws_vpc" "multitier" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "vpc-multitier"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.multitier.id}"
}

/*
  Public Subnet
*/
resource "aws_subnet" "vpc-multitier-public" {
    vpc_id = "${aws_vpc.multitier.id}"

    cidr_block = "${var.public_subnet_cidr}"
    tags {
        Name = "multitier-public-subnet"
    }
}

resource "aws_route_table" "vpc-multitier-public" {
    vpc_id = "${aws_vpc.multitier.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "multitier-public-subnet-rtb"
    }
}

resource "aws_route_table_association" "vpc-multitier-public" {
    subnet_id = "${aws_subnet.vpc-multitier-public.id}"
    route_table_id = "${aws_route_table.vpc-multitier-public.id}"
}


/* NAT Gateway */
resource "aws_eip" "nat" {
    vpc = true
}

resource "aws_nat_gateway" "gw" {
    allocation_id = "${aws_eip.nat.id}"
    subnet_id = "${aws_subnet.vpc-multitier-public.id}"
}

/*
  Private Subnet
*/
resource "aws_subnet" "vpc-multitier-private" {
    vpc_id = "${aws_vpc.multitier.id}"

    cidr_block = "${var.private_subnet_cidr}"
    tags {
        Name = "multitier-private-subnet"
    }
}

resource "aws_route_table" "vpc-multitier-private" {
    vpc_id = "${aws_vpc.multitier.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.gw.id}"
    }

    tags {
        Name = "multitier-private-subnet-rtb"
    }
}

resource "aws_route_table_association" "vpc-multitier-private" {
    subnet_id = "${aws_subnet.vpc-multitier-private.id}"
    route_table_id = "${aws_route_table.vpc-multitier-private.id}"
}


/* s3 access to private subnet */
resource "aws_vpc_endpoint" "private-s3-endpoint" {
    vpc_id = "${aws_vpc.multitier.id}"
    service_name = "${lookup(var.s3endpoint, var.aws_region)}"

    route_table_ids = ["${aws_route_table.vpc-multitier-private.id}"]
}

/* Security Groups */
resource "aws_security_group" "bastion-security" {
  name = "bastion-security"
  description = "Bastion Node Security Rules"
  vpc_id = "${aws_vpc.multitier.id}"

  ingress {
      from_port = 22
      to_port = 22
      protocol = "6"
      cidr_blocks = ["${var.tunnel_server}/32"]
  }

  ingress {
      from_port = 7000
      to_port = 7000
      protocol = "6"
      cidr_blocks = ["${var.private_subnet_cidr}"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      /* cidr_blocks = ["${var.private_subnet_cidr}"] - this causes problems for yum updates in the bastion nodes */
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private-subnet-security" {
  name = "private-subnet-security"
  description = "security group for instances in private subnet"
  vpc_id = "${aws_vpc.multitier.id}"

  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      security_groups = ["${aws_security_group.bastion-security.id}"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}
