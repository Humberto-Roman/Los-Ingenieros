output "bucket_name" {
  description = "Nombre del bucket creado"
  value       = aws_s3_bucket.p12.bucket
}

output "bucket_arn" {
  description = "ARN del bucket"
  value       = aws_s3_bucket.p12.arn
}

output "bucket_region" {
  description = "Región del bucket"
  value       = var.aws_region
}

output "versioning_status" {
  description = "Estado del versionado"
  value       = aws_s3_bucket_versioning.p12.versioning_configuration[0].status
}
