output "s3_bucket_name" {
  description = "The name of my S3 bucket"
  value       = aws_s3_bucket.demo.bucket
}
