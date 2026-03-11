resource "aws_cloudformation_stack_set" "role" {
  name          = format("%s-role", local.name)
  description   = "Provisions IAM roles for AWS Backup"
  template_body = local.cf_role_tpl

  permission_model = "SERVICE_MANAGED"

  capabilities = [
    "CAPABILITY_NAMED_IAM",
    "CAPABILITY_AUTO_EXPAND",
    "CAPABILITY_IAM",
  ]

  tags = merge(local.tags, { Name = local.name })

  auto_deployment {
    enabled                          = true
    retain_stacks_on_account_removal = false
  }

  operation_preferences {
    failure_tolerance_count   = 0
    max_concurrent_percentage = 100
    region_concurrency_type   = "PARALLEL"
  }

  lifecycle {
    ignore_changes = [administration_role_arn]
  }
}

resource "aws_cloudformation_stack_set_instance" "role" {
  for_each = toset(local.all_role_names)

  stack_set_name            = aws_cloudformation_stack_set.role.name
  stack_set_instance_region = local.backup_region

  parameter_overrides = {
    RoleName = each.value
    RolePath = "/backup/"
  }

  deployment_targets {
    organizational_unit_ids = local.target_ou_ids
  }
}
