terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "rmrt1n"
    workspaces {
      name = "github-actions-goat"
    }
  }
}

provider "aws" {
  region = var.region
}

# ecr
resource "aws_ecr_repository" "goat_ecr" {
  name = "goat-ecr"
  tags = local.tags
}

# dockerrun config file
# this file should be zipped. see data.tf
resource "local_file" "dockerrun" {
  content = jsonencode({
    AWSEBDockerrunVersion = "1"
    Image = {
      Name   = "${local.ecr_url}/${var.container_image_name}:latest"
      Update = "true"
    }
    Ports = [
      {
        ContainerPort = var.container_port
        HostPort      = 80
      }
    ]
  })
  filename = local.dockerrun_filename
}

# s3 bucket to store dockerrun file
resource "aws_s3_bucket" "dockerrun_bucket" {
  bucket = "goat-s3-dockerrun-bucket"
  acl    = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = local.tags
}

# bucket object
resource "aws_s3_bucket_object" "dockerrun_object" {
  key    = local.dockerrun_filename
  bucket = aws_s3_bucket.dockerrun_bucket.id
  source = local_file.dockerrun.filename
  tags   = local.tags
}

# iam instance profile for eb
resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "goat-aws-elasticbeanstalk-ec2-profile"
  role = aws_iam_role.eb_ec2_role.name
  tags = local.tags
}

# role for profile
resource "aws_iam_role" "eb_ec2_role" {
  name               = "goat-aws-elasticbeanstalk-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
  tags = local.tags
}

# eb application
resource "aws_elastic_beanstalk_application" "eb_app" {
  name        = "goat"
  description = "github clone"
  tags        = local.tags
}

# eb app version
resource "aws_elastic_beanstalk_application_version" "eb_app_ver" {
  name        = local.dockerrun_hash
  application = aws_elastic_beanstalk_application.eb_app.name
  bucket      = aws_s3_bucket.dockerrun_bucket.id
  key         = local.dockerrun_filename
  tags        = local.tags
}

# eb application environment uses default instance profile for eb
resource "aws_elastic_beanstalk_environment" "eb_app_env" {
  name                = "goat-env"
  application         = aws_elastic_beanstalk_application.eb_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.4.7 running Docker"
  version_label       = aws_elastic_beanstalk_application_version.eb_app_ver.name
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }
  tags = local.tags
}
