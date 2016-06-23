This repository is used to setup a VPC with Dynamic DNS mapping within clusters
launched with [Qubole](https://api.qubole.com). This allows each node in
Qubole's ephemeral clusters to have custom DNS names

The terraform template is based on the
[aws-labs](https://github.com/awslabs/aws-lambda-ddns-function) github repo
