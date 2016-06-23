/* cloudwatch event rule associated with our lambda handler in lambda.tf */

resource "aws_cloudwatch_event_rule" "ec2_lambda_ddns_rule" {
  name = "ec2-instance-state-change"
  description = "Capture each AWS EC2 Instance State-change operation"
  event_pattern = <<PATTERN
{
  "source": [
    "aws.ec2"
  ],
  "detail-type": [
    "EC2 Instance State-change Notification"
  ],
  "detail": {
    "state": ["running", "shutting-down", "stopped"]
  }
}
PATTERN
}

/* send all ec2 instance state change events to lambda function */
resource "aws_cloudwatch_event_target" "ec2_lambda_ddns_target" {
  rule = "${aws_cloudwatch_event_rule.ec2_lambda_ddns_rule.name}"
  target_id = "Id14123213091"
  arn = "${aws_lambda_function.lambda-cw-resolver-fn.arn}"
}
