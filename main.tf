module "network" {
  source               = "./modules/network"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_count  = 2
  private_subnet_count = 2
}

module "ecr" {
  source   = "./modules/ecr"
  services = var.services
}

module "logs" {
  source   = "./modules/logs"
  services = var.services
  retention_in_days = 30
}

module "iam" {
  source = "./modules/iam"
}

module "route53" {
  source        = "./modules/route53"
  domain_name   = var.domain_name
  alb_dns_name  = module.alb.dns_name
  alb_zone_id   = module.alb.zone_id
}

module "acm" {
  source      = "./modules/acm"
  domain_name = var.domain_name
  zone_id     = module.route53.zone_id
}

module "alb" {
  source            = "./modules/alb"
  services          = var.services
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  certificate_arn   = module.acm.certificate_arn
}

module "ecs" {
  source              = "./modules/ecs"
  services            = var.services
  ecr_repos           = module.ecr.repositories
  subnet_ids          = module.network.private_subnet_ids
  security_group_ids  = [module.alb.alb_sg_id]
  cluster_name        = "muzique-cluster"
  target_group_arns   = module.alb.target_group_arns
  task_role_arn       = module.iam.ecs_task_role_arn
  execution_role_arn  = module.iam.ecs_execution_role_arn
  aws_region          = var.aws_region
  desired_count       = 2
}