output "entrypoint_url" {
  description = "application url"
  value       = aws_elastic_beanstalk_environment.eb_app_env.cname
}
