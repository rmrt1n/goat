provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_ecr_repository" "ecr" {
  name = "goat-registry"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_elastic_beanstalk_application" "goat" {
  name = "goat"
  description = "github clone"
}

resource "aws_elastic_beanstalk_environment" "goat_env" {
  name = "goat"
  application = aws_elastic_beanstalk_application.goat.name
  solution_stack_name = "64bit Amazon Linux 2 v3.4.7 running Docker"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = "aws-elasticbeanstalk-ec2-role"
  }
}
