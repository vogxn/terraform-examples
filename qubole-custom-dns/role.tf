/**
 Creates an IAM role for DDNS using CloudWatch events and Lambda.
 `ref`: https://github.com/awslabs/aws-lambda-ddns-function
**/

resource "aws_iam_role" "lambda-route53" {
  name = "lambda-route53"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda-route53-policy" {
  name = "lambda-route53-policy"
  role = "${aws_iam_role.lambda-route53.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": "ec2:Describe*",
    "Resource": "*"
  }, {
    "Effect": "Allow",
    "Action": [
      "dynamodb:*"
    ],
    "Resource": "*"
  }, {
    "Effect": "Allow",
    "Action": [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ],
    "Resource": "*"
  }, {
    "Effect": "Allow",
    "Action": [
      "route53:*"
    ],
    "Resource": [
      "*"
    ]
  }]
}
EOF
}
