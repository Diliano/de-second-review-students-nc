data "archive_file" "lambda" {
  type             = "zip"
  output_file_mode = "0666"
  source_file      = "${path.module}/../src/quotes.py"
  output_path      = "${path.module}/../function.zip"
}

data "archive_file" "layer" {
  #TODO: Use this archive_file block to create a deployment package for the layer.
  type             = "zip"
  output_file_mode = "0666"
  source_dir       = "${path.module}/../layer"
  output_path      = "${path.module}/../layer-zip/layer.zip"
}

resource "aws_lambda_layer_version" "requests_layer" {
  layer_name          = "requests_layer"
  compatible_runtimes = [var.python_runtime]
  s3_bucket           = aws_s3_bucket.code_bucket.bucket
  s3_key              = aws_s3_object.layer_code.key
}

resource "aws_lambda_function" "quote_handler" {
  #TODO: Provision the lambda
  #TODO: Connect the layer which is outlined above
  function_name = var.lambda_name
  s3_bucket     = aws_s3_bucket.code_bucket.bucket
  s3_key        = aws_s3_object.lambda_code.key
  role          = aws_iam_role.lambda_role.arn
  handler       = "quotes.lambda_handler"
  runtime       = var.python_runtime
  layers        = [aws_lambda_layer_version.requests_layer.arn]

  environment {
    variables = {
      "S3_BUCKET_NAME" = aws_s3_bucket.data_bucket.bucket
    }
  }

  timeout = 30
}
