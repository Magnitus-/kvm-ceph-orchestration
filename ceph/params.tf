locals {
  params = jsondecode(file("${path.module}/../params.json"))
}