# terraform-qubole-vpc
Terraform template to setup a VPC with multiple tiers (public and private
subnets) for use with [Qubole](https://api.qubole.com)

# Setup

* Your AWS creds are read from the configured aws-cli or through environment
  variables (`AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY`)
* You will need to install [terraform](http://www.terraform.io) to get started
* You will need the public IP of the tunnel server that Qubole has assigned for you
* You will also be providing your public key (OpenSSH RSA format) and the
  corresponding key pair name with which to launch the bastion host.
* The variables file contains all the parts of the VPC that you will want to customise
  + region of the VPC
  + CIDR of the vpc, and its constituent private and public subnets
* Place the public key of qubole in the `public_key.pub` file
* Run `terraform plan` to show you the outline of the final setup
* To see the VPC setup as a digraph use `terraform graph`
* To apply the changes run `terraform apply`
* To apply with variables:

> `terraform apply -var aws_region="<vpc-target-region>" -var
> tunnel_server="<qubole-tunnel-server>" -var
> deployment_key_name="my-aws-keyname" -var deployment_pub_key="ssh-rsa
> <pub-key-string>"`
