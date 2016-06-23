/** Lambda function that responds to CloudWatch events of EC2 Instance
Startup, Shutdown and Terminate. Adds/Removes A and PTR records to the private
VPC hosted zone **/

resource "aws_lambda_function" "lambda-cw-resolver-fn" {
  filename = "union.py.zip"
  function_name = "ddns_lambda"
  runtime = "python2.7"
  description = "adds / removes records in route53 in response to cloudwatch instance start/termination events"
  role = "${aws_iam_role.lambda-route53.arn}"
  source_code_hash = "${base64sha256(file("union.py.zip"))}"
  handler = "union.lambda_handler"
}


/* allow cloudwatch to invoke this lambda function */
resource "aws_lambda_permission" "allow_cloudwatch" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.lambda-cw-resolver-fn.arn}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.ec2_lambda_ddns_rule.arn}"
}
