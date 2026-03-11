resource "aws_cloudformation_stack_set" "vault" {
  for_each = {
    for v in values(local.vaults) : v.name => v
  }

  name          = lower(format("%s-vault-%s", local.name, each.key))
  description   = "Provisions Vaults for AWS Backup (per OU/account via StackSets)"
  template_body = local.cf_vault_tpl

  parameters = {
    VaultName                 = "BackupVault"
    VaultLockChangeableDays   = 0
    VaultLockMinRetentionDays = 0
    VaultLockMaxRetentionDays = 0
  }

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

resource "aws_cloudformation_stack_set_instance" "vault" {
  for_each = local.vaults_per_region

  stack_set_name            = aws_cloudformation_stack_set.vault[each.value.vault.name].name
  stack_set_instance_region = tostring(each.value.region)

  parameter_overrides = {
    VaultName                 = each.value.vault.name
    VaultLockChangeableDays   = each.value.vault.change_grace_days
    VaultLockMinRetentionDays = each.value.vault.min_retention_days
    VaultLockMaxRetentionDays = each.value.vault.max_retention_days
  }

  deployment_targets {
    organizational_unit_ids = local.target_ou_ids
  }
}
