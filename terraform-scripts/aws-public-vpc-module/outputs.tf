output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC id"
}

output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "Subnet Id"
}