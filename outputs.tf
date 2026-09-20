output "alb_dns_name" {
  description = "Public DNS URL of the Application Load Balancer"
  value       = aws_lb.external_alb.dns_name
}
