/* create a route53 private hosted zone */

resource "aws_route53_zone" "qubole-dns" {
  name = "qubole-dns.net"
  comment = "Qubole Custom DNS Zone"
  vpc_id = "${aws_vpc.qubole-vpc-customdns.id}"
}

/* DHCP Options */
resource "aws_vpc_dhcp_options" "qubole_custom_dhcp" {
  domain_name = "qubole-dns.net ec2.internal compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
}

resource "aws_vpc_dhcp_options_association" "qubole_custom_dhcp_assoc" {
    vpc_id = "${aws_vpc.qubole-vpc-customdns.id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.qubole_custom_dhcp.id}"
}
