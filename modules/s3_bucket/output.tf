#Esta salida muestra el ARN del bucket de S3 creado por el recurso aws_s3_bucket.s3_test
output "bucket_arn" {
  value = aws_s3_bucket.s3_test.arn
}
#Esta salida muestra el ID del bucket de S3 creado por el recurso aws_s3_bucket.s3_test
output "bucket_id" {
  value = aws_s3_bucket.s3_test.id
}