/*
  Bastion Node
*/

resource "aws_instance" "bastion_node" {
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "m3.medium"
    key_name = "${aws_key_pair.deployment-key.key_name}"
    security_groups = ["${aws_security_group.bastion-security.id}"]
    subnet_id = "${aws_subnet.vpc-multitier-public.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "vpc-multitier-bastion"
    }

    provisioner "file" {
        source = "public_key.pub"
        destination = "/tmp/public_key.pub"
    }

    provisioner "remote-exec" {
        inline = [
          "cat /tmp/public_key.pub >> /home/ec2-user/.ssh/authorized_keys"
        ]
    }
}
