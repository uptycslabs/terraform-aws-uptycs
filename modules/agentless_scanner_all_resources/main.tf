
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id  = data.aws_caller_identity.current.account_id
  region_code = data.aws_region.current.name
  tags        = merge(var.additional_tags, { "CreatedBy" = "${var.resources_prefix}-agentless" })
  ami_map = {
    "us-west-2" : "ami-02d5622660e852be0"
    "us-west-1" : "ami-0eb917bd5c3b95e02"
    "us-east-2" : "ami-0fddca2efe6e54d98"
    "us-east-1" : "ami-07719efefe896200a"
  }
}

#iam resources -------------------------------------------------

locals {
  scanner_iam_role_name = "${var.resources_prefix}-agentless-scanner"
  monitor_iam_role_name = "${var.resources_prefix}-agentless-monitor"
  target_iam_role_name  = "${var.resources_prefix}-agentless-target"

  scanner_instance_profile_name = "${var.resources_prefix}-agentless-scanner-profile"
  monitor_instance_profile_name = "${var.resources_prefix}-agentless-monitor-profile"

  scanner_iam_role_arn = "arn:aws:iam::${local.account_id}:role/${local.scanner_iam_role_name}"
}

resource "aws_iam_role" "uptycs_scanner_role" {
  count = var.is_default_region ? 1 : 0

  name                 = local.scanner_iam_role_name
  assume_role_policy   = templatefile("${path.module}/../../templates/agentless-scanner-trust-policy.json.tpl", {})
  tags                 = local.tags
  permissions_boundary = var.scanner_role_pb_policy_arn

  inline_policy {
    name = "UptycsAgentlessScannerPolicy"
    policy = templatefile("${path.module}/../../templates/agentless-scanner-iam-policy.json.tpl", {
      target_iam_role_name = local.target_iam_role_name
      resource_tag         = local.tags["CreatedBy"]
    })
  }
}

resource "aws_iam_instance_profile" "scanner_instance_profile" {
  count = var.is_default_region ? 1 : 0

  name = local.scanner_instance_profile_name
  role = aws_iam_role.uptycs_scanner_role[0].name
  tags = local.tags
}

resource "aws_iam_role" "uptycs_monitor_role" {
  count = var.is_default_region ? 1 : 0

  name                 = local.monitor_iam_role_name
  assume_role_policy   = templatefile("${path.module}/../../templates/agentless-monitor-trust-policy.json.tpl", {})
  tags                 = local.tags
  permissions_boundary = var.monitor_role_pb_policy_arn

  inline_policy {
    name = "UptycsAgentlessMonitorPolicy"
    policy = templatefile("${path.module}/../../templates/agentless-monitor-iam-policy.json.tpl", {
      resource_tag               = local.tags["CreatedBy"]
      scanner_iam_role_arn       = local.scanner_iam_role_arn
      apifile_encryption_key_arn = aws_kms_key.primary_key.arn
    })
  }
}

resource "aws_iam_instance_profile" "monitor_instance_profile" {
  count = var.is_default_region ? 1 : 0

  name = local.monitor_instance_profile_name
  role = aws_iam_role.uptycs_monitor_role[0].name
  tags = local.tags
}




#kms resources -------------------------------------------------

resource "aws_kms_key" "primary_key" {
  description             = "Uptycs side scanner KMS key"
  deletion_window_in_days = 7
  policy = templatefile("${path.module}/../../templates/agentless-kms-key-policy.json.tpl", {
    account_id       = local.account_id
    organization_ids = [var.organization_id]
  })
  tags = local.tags
}

#key pair  --------------------------------------------------

locals {
  scanner_key_name = "${var.resources_prefix}-agentless-scanner-key"
}

module "key_pair" {
  source             = "terraform-aws-modules/key-pair/aws"
  key_name           = local.scanner_key_name
  create_private_key = true
}

# vpc resources  ---------------------------------------

locals {
  vpc_name         = "${var.resources_prefix}-agentless-vpc"
  subnet_name      = "${var.resources_prefix}-agentless-subnet"
  ig_name          = "${var.resources_prefix}-agentless-ig"
  route_table_name = "${var.resources_prefix}-agentless-route-table"
}

resource "aws_vpc" "agentless_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = merge(
    local.tags,
    {
      Name : local.vpc_name
    }
  )
}

resource "aws_subnet" "agentless_subnet" {
  vpc_id     = aws_vpc.agentless_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = merge(
    local.tags,
    {
      Name : local.subnet_name
    }
  )
}

resource "aws_internet_gateway" "agentless_igw" {
  vpc_id = aws_vpc.agentless_vpc.id
  tags = merge(
    local.tags,
    {
      Name : local.ig_name
    }
  )
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.agentless_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.agentless_igw.id
  }
  tags = merge(
    local.tags,
    {
      Name : local.route_table_name
    }
  )
}

resource "aws_route_table_association" "public_route_association" {
  subnet_id      = aws_subnet.agentless_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# scanner resources ----------------------------------------------


locals {
  scanner_instance_template_name = "${var.resources_prefix}-agentless-scanner-instance-tpl"
  scanner_security_group_name    = "${var.resources_prefix}-agentless-scanner-sg"

  scanner_instance_size = "r5b.2xlarge"

  user-data = "" // this is static and will be provided soon
}

resource "aws_security_group" "scanner_security_group" {
  name        = local.scanner_security_group_name
  description = "Security group for uptycs side scanning"
  vpc_id      = aws_vpc.agentless_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.tags,
    {
      Name : local.scanner_security_group_name
    }
  )
}



resource "aws_launch_template" "scanner_template" {
  name                   = local.scanner_instance_template_name
  image_id               = local.ami_map[local.region_code]
  instance_type          = local.scanner_instance_size
  update_default_version = true
  key_name               = module.key_pair.key_pair_name
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.scanner_security_group.id]
  }

  user_data = local.user-data

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = 60
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    name = local.scanner_instance_profile_name // resource dependancy with scanner_instance_profile handled at monitor_asg
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      local.tags,
      {
        Name : "Uptycs Agentless Scanner"
      }
    )
  }

  tag_specifications {
    resource_type = "volume"
    tags          = local.tags
  }
  tags = local.tags
}


# monitor resources [only on default region] ----------------------------------------------

locals {
  monitor_instance_template_name = "${var.resources_prefix}-agentless-monitor-instance-tpl"
  monitor_security_group_name    = "${var.resources_prefix}-agentless-monitor-sg"
  monitor_instance_name          = "${var.resources_prefix}-agentless-monitor-instance"
  monitor_instance_volume        = "${var.resources_prefix}-agentless-monitor-volume"
  monitor_instance_size          = "t3.nano"
  monitor_asg_name_prefix        = "${var.resources_prefix}-agentless-monitor-asg-"
}


resource "aws_security_group" "monitor_security_group" {
  count = var.is_default_region ? 1 : 0

  name        = local.monitor_security_group_name
  description = "Security group for uptycs side scanning"
  vpc_id      = aws_vpc.agentless_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.tags,
    {
      Name : local.monitor_security_group_name
    }
  )
}


resource "aws_launch_template" "monitor_template" {
  count = var.is_default_region ? 1 : 0

  name                   = local.monitor_instance_template_name
  image_id               = local.ami_map[local.region_code]
  instance_type          = local.monitor_instance_size
  update_default_version = true
  key_name               = module.key_pair.key_pair_name
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.monitor_security_group[0].id]
  }

  user_data = local.user-data

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = 60
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.monitor_instance_profile[0].name
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      local.tags,
      {
        Name : local.monitor_instance_name
      }
    )
  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(
      local.tags,
      {
        Name : local.monitor_instance_volume
      }
    )
  }
  tags = local.tags
}



resource "aws_autoscaling_group" "monitor_asg" {
  count = var.is_default_region ? 1 : 0

  name_prefix         = local.monitor_asg_name_prefix
  min_size            = 1
  max_size            = 1
  desired_capacity    = 1
  health_check_type   = "EC2"
  vpc_zone_identifier = [aws_subnet.agentless_subnet.id]
  launch_template {
    id      = aws_launch_template.monitor_template[0].id
    version = "$Latest"
  }
  dynamic "tag" {
    for_each = local.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_iam_instance_profile.scanner_instance_profile] // dependancy related to scanner_template

}
