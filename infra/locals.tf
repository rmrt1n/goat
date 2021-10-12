locals {
  tags = {
    application = "goat"
    created_by  = "terraform"
  }

  ecr_url        = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
  s3_key         = "Dockerrun.aws.json"
  dockerrun_hash = sha256(local_file.dockerrun.content)
}
