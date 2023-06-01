# AWS bucket s3
#random_string - Este recurso genera una cadena aleatoria utilizada como parte del nombre del bucket. 
#La longitud de la cadena se establece en 4 caracteres y no contiene caracteres especiales.
resource "random_string" "bucket_name" {
  length  = 4
  special = false
}
#Este recurso crea un bucket de S3 en AWS. El nombre del bucket se compone 
#concatenando el nombre del bucket generado aleatoriamente 
resource "aws_s3_bucket" "s3_test" {
  bucket        = "${var.bucket_name}_${random_string.bucket_name.result}"
  force_destroy = true

  tags = {
    Name        = "bucket_test_${var.environment}"
    Environment = var.environment
  }
}
#Este recurso configura los controles de propiedad del bucket de S3
#"BucketOwnerPreferred", lo que significa que el propietario del bucket 
#es el propietario predeterminado de los objetos dentro del bucket.
resource "aws_s3_bucket_ownership_controls" "acl_test" {
  bucket = aws_s3_bucket.s3_test.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
#Este recurso establece la configuración de control de acceso (ACL) para el bucket de S3. 
#Aquí se configura la ACL en "private", lo que significa que solo el propietario del bucket 
#y las cuentas autorizadas tienen acceso al bucket y sus objetos.
resource "aws_s3_bucket_acl" "acl_test" {
  depends_on = [aws_s3_bucket_ownership_controls.acl_test]
  bucket     = aws_s3_bucket.s3_test.id
  acl        = "private"
}
#Este recurso habilita o suspende el versionamiento del bucket de S3
resource "aws_s3_bucket_versioning" "versioning_s3" {
  bucket = aws_s3_bucket.s3_test.id
  versioning_configuration {
    status = var.versioning_status ? "Enabled" : "Suspended"
  }
}
#Este recurso permite crear una política de bucket de S3
resource "aws_s3_bucket_policy" "s3_policy" {
  count  = var.enable_bucket_policy == true ? 1 : 0
  bucket = aws_s3_bucket.s3_test.id
  policy = var.bucket_policy
}
#Este recurso configura la encriptación del lado del servidor para el bucket de S3 con kms
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption_kms" {
  count  = var.encrypt_with_kms == true ? 1 : 0
  bucket = aws_s3_bucket.s3_test.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_master_key_id
      sse_algorithm     = "aws:kms"
    }
  }
}
#Este recurso configura la encriptación del lado del servidor para el bucket de S3 con aes
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption_aes" {
  count  = var.encrypt_with_kms == false ? 1 : 0
  bucket = aws_s3_bucket.s3_test.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
