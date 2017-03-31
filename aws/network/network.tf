module "vpc" {
  source = "./vpc"

  project              = "${var.project}"
  environment          = "${var.environment}"
  name                 = "${var.name}"
  cidr                 = "${var.vpc_cidr}"
  enable_dns_support   = "${var.vpc_enable_dns_support}"
  enable_dns_hostnames = "${var.vpc_enable_dns_hostnames}"
}

module "public_subnet" {
  source = "./public_subnet"

  project     = "${var.project}"
  environment = "${var.environment}"
  name        = "${var.name}"
  vpc_id      = "${module.vpc.id}"
  cidrs       = "${var.public_subnet_cidrs}"
  azs         = "${var.azs}"
}

/*module "nat" {
  source = "./nat"

  project = "${var.project}"
  environment = "${var.environment}"
  azs               = "${var.azs}"
  public_subnet_ids = "${module.public_subnet.subnet_ids}"
}*/

# The reason for this is that ephemeral nodes (nodes that are recycled often like ASG nodes),

# need to be in separate subnets from long-running nodes (like Elasticache and RDS) because

# AWS maintains an ARP cache with a semi-long expiration time.

# So if node A with IP 10.0.0.123 gets terminated, and node B comes in and picks up 10.0.0.123

# in a relatively short period of time, the stale ARP cache entry will still be there,

# so traffic will just fail to reach the new node.

/*module "ephemeral_subnets" {
  source = "./private_subnet"

  project = "${var.project}"
  environment = "${var.environment}"
  vpc_id = "${module.vpc.id}"
  cidrs  = "${var.ephemeral_subnets}"
  azs    = "${var.azs}"

#  nat_gateway_ids = "${module.nat.nat_gateway_ids}"
}*/

module "private_subnet" {
  source = "./private_subnet"

  project     = "${var.project}"
  environment = "${var.environment}"
  name        = "${var.name}"
  vpc_id      = "${module.vpc.id}"
  cidrs       = "${var.private_subnet_cidrs}"
  azs         = "${var.azs}"

  # nat_gateway_ids = "${module.nat.nat_gateway_ids}"
}
