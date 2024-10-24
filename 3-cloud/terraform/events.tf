resource "aws_cloudwatch_event_rule" "scheduler" {
  #TODO: this should set up a scheduler that will trigger the Lambda every 5 minutes
  # Careful! other things may need to be set up as well
  description         = "Trigger the lambda every 5 minutes"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "target_lambda" {
  rule      = aws_cloudwatch_event_rule.scheduler.name
  target_id = "QuoteHandlerLambda"
  arn       = aws_lambda_function.quote_handler.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.quote_handler.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduler.arn
}
