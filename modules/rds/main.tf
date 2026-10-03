resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "scalable-web-rds-subnet-group"

  subnet_ids = [
    var.private_subnet_1a,
    var.private_subnet_1b
  ]

  tags = {
    Name        = "scalable-web-rds-subnet-group"
    Environment = "dev"
  }
}

# Generate a strong random password
resource "random_password" "db_password" {
  length  = 16
  special = false
  
}

# Create a Secrets Manager secret to hold the password
resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = "arn:aws:secretsmanager:ap-south-1:586988810446:secret:scalable-web-postgres-credentials-OhlJCu"
   secret_string = random_password.db_password.result
   
}

# RDS Instance
resource "aws_db_instance" "postgres" {
  identifier = "scalable-web-postgres"

  engine         = "postgres"
  engine_version = "15.19"   # ✅ use a valid version
  instance_class = var.db_instance_class

  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = random_password.db_password.result   # 🔹 use generated password

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [var.rds_sg_id]

  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Name        = "scalable-web-postgres"
    Environment = "dev"
  }
}