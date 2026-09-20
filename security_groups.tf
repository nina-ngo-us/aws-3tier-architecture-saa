# Security Group for ALB (Public Access)
resource "aws_security_group" "alb_sg" {
  name        = "3tier-alb-sg"
  description = "Allow HTTP inbound traffic to ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "3tier-alb-sg"
    Environment = var.environment
  }
}

# Security Group for EC2 App Tier
resource "aws_security_group" "app_sg" {
  name        = "3tier-app-sg"
  description = "Allow traffic only from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from ALB SG"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "3tier-app-sg"
    Environment = var.environment
  }
}

# Security Group for RDS Database Tier
resource "aws_security_group" "db_sg" {
  name        = "3tier-db-sg"
  description = "Allow MySQL traffic only from App EC2 SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL from App SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "3tier-db-sg"
    Environment = var.environment
  }
}
