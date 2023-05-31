resource "aws_kms_key" "kms_test" {
  description             = "encrypt_bucket_objects"
  deletion_window_in_days = var.deletion_window_in_days
}
#que significa una llave kms para que sirve una politica en la llave - que es key rotation 
#que pasa si borro la llave de kms