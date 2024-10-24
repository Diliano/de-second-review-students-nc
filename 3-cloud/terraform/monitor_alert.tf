/*
I have tried to fill in the boilerplate resources from the registry,
however I did not finish in time or try to plan/apply
*/


resource "aws_cloudwatch_log_metric_filter" "great_quote_filter" {
  name           = "GreatQuoteFilter"
  pattern        = "[GREAT QUOTE]"
  log_group_name = "/aws/lambda/${var.lambda_name}"

  metric_transformation {
    name      = "GreatQuoteCount"
    namespace = "QuoteGetter"
    value     = "1"
  }
}

resource "aws_sns_topic" "great_quote_alert" {
  name = "great-quote-alert"
}

resource "aws_sns_topic_subscription" "great_quote_email_subscription" {
  topic_arn = aws_sns_topic.great_quote_alert.arn
  protocol  = "email"
  endpoint  = "dataengineering@northcoders.com"
}

resource "aws_cloudwatch_metric_alarm" "great_quote_alarm" {
  alarm_name          = "great-quote-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.great_quote_filter.metric_transformation.name
  namespace           = aws_cloudwatch_log_metric_filter.great_quote_filter.metric_transformation.namespace
  threshold           = 1
  alarm_description   = "This metric monitors [GREAT QUOTE] being logged via the lambda function"
  alarm_actions       = [aws_sns_topic.great_quote_alert.arn]
}
