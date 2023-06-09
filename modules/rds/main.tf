#   #   # aws RDS INSTANCE #  #   #
resource "random_password" "password_test" {
  length  = 8
  special = false
}
resource "aws_db_instance" "rds_test" {
  allocated_storage      = 10
  db_name                = var.name
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = var.user-name
  password               = random_password.password_test.result
  vpc_security_group_ids = [aws_security_group.seg_rds.id]
  db_subnet_group_name   = aws_db_subnet_group.subg_rds.id
  port                   = 3346
  availability_zone      = var.availability_zone
  multi_az               = var.multi_az
  skip_final_snapshot    = true
  max_allocated_storage  = 100
}

#   #   # AWS SECURITY GROUP #  #   #
resource "aws_security_group" "seg_rds" {
  name        = "seg_rds"
  description = "security_group_rds"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 3346
    to_port     = 3346
    protocol    = "tcp"
    cidr_blocks = [var.cidr_to_allow]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "security_gruop_rds_${var.environment}"
  }
}
#   #   # AWS SUBNET GROUP #  #   #
resource "aws_db_subnet_group" "subg_rds" {
  name       = "subg_rds"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "subnet_group_rds_${var.environment}"
  }
}