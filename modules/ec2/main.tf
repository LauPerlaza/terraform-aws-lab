#   #   # AWS_INSTANCE #    #      #
resource "aws_instance" "instance_test" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = "keyec2terraform"

  vpc_security_group_ids = var.sg_ids

  tags = {
    Name        = "${var.name}_${var.environment}"
    Environment = var.environment
    CreatedBy   = "terraform"
  }
}
