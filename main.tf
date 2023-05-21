module "policy_test" {
  source = "./modules/iam_policy"
  region      = var.region
  environment = var.environment
}
module "networking_test" {
  source      = "./modules/networking"
  region      = var.region
  environment = var.environment
}