resource "aws_directory_service_directory" "this" {
  name     = var.name
  password = var.password
  edition  = var.edition
  type     = "MicrosoftAD"

  vpc_settings {
    vpc_id     = var.vpc_id
    subnet_ids = var.subnet_ids
  }
}
