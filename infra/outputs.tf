output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_url" {
  description = "HTTP URL of the ALB"
  value       = "http://${module.alb.alb_dns_name}"
}

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = module.web_asg.asg_name
}

output "target_group_arn" {
  description = "Target Group ARN"
  value       = module.alb.target_group_arn
}
