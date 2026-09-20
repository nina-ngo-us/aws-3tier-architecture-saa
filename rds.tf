resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "threetier-rds-subnet-group"
  subnet_ids = [aws_subnet.private_db_1.id, aws_subnet.private_db_2.id]

  tags = {
    Name        = "3tier-rds-subnet-group"
    Environment = var.environment
  }
}

resource "aws_db_instance" "rds_db" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "appdb"
  username               = "admin"
  password               = "DatabasePass123!"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name        = "3tier-rds-db"
    Environment = var.environment
  }
}
