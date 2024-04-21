output "url" {
  # value = module.ec2.url
  value = "http://${module.alb.dns_name}"
}
