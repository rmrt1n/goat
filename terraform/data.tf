data "aws_caller_identity" "current" {}

data "archive_file" "dockerrun_zip" {
  type = "zip"
  source_file = local_file.dockerrun.filename
  output_path = "${path.module}/Dockerrun.aws.zip"
}
