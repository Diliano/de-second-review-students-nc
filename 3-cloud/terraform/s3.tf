resource "aws_s3_bucket" "data_bucket" {
  #TODO: Provision an S3 bucket for the data. 
  #TODO: Your bucket will need a unique, but identifiable name. Hint: Use the vars. 
  #TODO: Make sure to add an appropriate tag to this resource
  bucket_prefix = var.data_bucket_prefix

  force_destroy = true

  tags = {
    Name = "data-bucket"
  }
}

resource "aws_s3_bucket" "code_bucket" {
  #TODO: Provision an S3 bucket for the lambda code. 
  #TODO: Your bucket will need a unique, but identifiable name. Hint: Use the vars. 
  #TODO: Make sure to add an appropriate tag to this resource
  bucket_prefix = var.code_bucket_prefix

  tags = {
    Name = "code-bucket"
  }
}

resource "aws_s3_object" "lambda_code" {
  #TODO: Upload the lambda code to the code_bucket.
  #TODO: See lambda.tf for the path to the code.
  bucket = aws_s3_bucket.code_bucket.bucket
  key    = "s3_quote_getter/function.zip"
  source = data.archive_file.lambda.output_path
}

resource "aws_s3_object" "layer_code" {
  #TODO: Upload the layer code to the code_bucket.
  #TODO: See lambda.tf for the path to the code.
  bucket = aws_s3_bucket.code_bucket.bucket
  key    = "s3_quote_getter/layer.zip"
  source = data.archive_file.layer.output_path
}

