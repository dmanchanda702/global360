data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  name_prefix = "${var.project}-${var.env}"
  azs         = slice(data.aws_availability_zones.available.names, 0, 2)

  common_tags = {
    NamePrefix  = local.name_prefix
    Project     = var.project
    Environment = var.env
    Owner       = var.owner
  }
}
module "network" {
  source = "./modules/network"

  name_prefix      = local.name_prefix
  vpc_cidr         = var.vpc_cidr
  azs              = local.azs
  ssh_ingress_cidr = var.ssh_ingress_cidr
  enable_ssh       = var.enable_ssh
  tags             = local.common_tags
}

module "alb" {
  source = "./modules/alb"

  name_prefix       = local.name_prefix
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.network.alb_sg_id
  tags              = local.common_tags
}

module "web_asg" {
  source = "./modules/web-asg"

  name_prefix      = local.name_prefix
  ami_id           = data.aws_ami.amazon_linux_2023.id
  instance_type    = var.instance_type
  key_name         = var.key_name
  app_sg_id        = module.network.app_sg_id
  subnet_ids       = module.network.public_subnet_ids
  target_group_arn = module.alb.target_group_arn

  desired_capacity = 2
  min_size         = 2
  max_size         = 3

  user_data = base64encode(file("${path.root}/user-data/nginx.sh"))
  tags      = local.common_tags
}
