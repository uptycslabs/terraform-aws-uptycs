module "agentless-resources-us-east-1" {
  count  = contains(var.scan_regions, "us-east-1") && local.default_region_found ? 1 : 0
  source = "../../modules/agentless_scanner_all_resources"

  resources_prefix           = var.resources_prefix
  is_default_region          = "us-east-1" == var.default_region
  organization_id            = var.organization_id
  scanner_role_pb_policy_arn = var.scanner_role_pb_policy_arn
  monitor_role_pb_policy_arn = var.monitor_role_pb_policy_arn
  additional_tags            = var.additional_tags

  providers = {
    aws = aws.us-east-1
  }
}

module "agentless-resources-us-east-2" {
  count  = contains(var.scan_regions, "us-east-2") && local.default_region_found ? 1 : 0
  source = "../../modules/agentless_scanner_all_resources"

  resources_prefix           = var.resources_prefix
  is_default_region          = "us-east-2" == var.default_region
  organization_id            = var.organization_id
  scanner_role_pb_policy_arn = var.scanner_role_pb_policy_arn
  monitor_role_pb_policy_arn = var.monitor_role_pb_policy_arn
  additional_tags            = var.additional_tags

  providers = {
    aws = aws.us-east-2
  }
}

module "agentless-resources-us-west-1" {
  count  = contains(var.scan_regions, "us-west-1") && local.default_region_found ? 1 : 0
  source = "../../modules/agentless_scanner_all_resources"

  resources_prefix           = var.resources_prefix
  is_default_region          = "us-west-1" == var.default_region
  organization_id            = var.organization_id
  scanner_role_pb_policy_arn = var.scanner_role_pb_policy_arn
  monitor_role_pb_policy_arn = var.monitor_role_pb_policy_arn
  additional_tags            = var.additional_tags

  providers = {
    aws = aws.us-west-1
  }
}

module "agentless-resources-us-west-2" {
  count  = contains(var.scan_regions, "us-west-2") && local.default_region_found ? 1 : 0
  source = "../../modules/agentless_scanner_all_resources"

  resources_prefix           = var.resources_prefix
  is_default_region          = "us-west-2" == var.default_region
  organization_id            = var.organization_id
  scanner_role_pb_policy_arn = var.scanner_role_pb_policy_arn
  monitor_role_pb_policy_arn = var.monitor_role_pb_policy_arn
  additional_tags            = var.additional_tags

  providers = {
    aws = aws.us-west-2
  }
}




# input checkes ---------------------------------------------

locals {
  default_region_found = contains(var.scan_regions, var.default_region)
  regions_string       = join(", ", var.scan_regions)
}


resource "null_resource" "error_default_region_not_in_scan_regions" {
  lifecycle {
    precondition {
      condition     = local.default_region_found
      error_message = "default_region = ${var.default_region} not found in regions = [${local.regions_string}]"
    }
  }
}

# providers --------------------------------------------------------------------------

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}

provider "aws" {
  alias  = "us-west-1"
  region = "us-west-1"
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}
