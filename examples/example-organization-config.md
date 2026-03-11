# Example organization configuration

Este exemplo ilustra como adaptar a configuração para uma organização fictícia.

## Organizational Units (OUs)

```hcl
locals {
  target_ou_ids = [
    "ou-aaaa-dev12345", # OU de desenvolvimento
    "ou-bbbb-qua12345", # OU de quality
    "ou-cccc-prd12345", # OU de produção
  ]
}
```

## Schedules e retenções de exemplo

```hcl
locals {
  backup_plans_input = {
    DEVELOPMENT = {
      schedule                = "cron(0 5 ? * * *)"   # diário às 05:00
      start_window_minutes    = 60
      complete_window_minutes = 300
      vault_name              = "backup-vault-dev"
      lifecycle = {
        delete_after_days = 14
      }
    }

    QUALITY = {
      schedule                = "cron(0 3 ? * * *)"   # diário às 03:00
      start_window_minutes    = 60
      complete_window_minutes = 300
      vault_name              = "backup-vault-qua"
      lifecycle = {
        delete_after_days = 30
      }
    }

    PRODUCTION = {
      schedule                = "cron(0 1 ? * * *)"   # diário às 01:00
      start_window_minutes    = 60
      complete_window_minutes = 300
      vault_name              = "backup-vault-prod"
      lifecycle = {
        delete_after_days = 90
      }
    }
  }
}
```

## Configuração de vaults de exemplo

```hcl
locals {
  vaults = {
    "backup-vault-dev" = {
      name               = "backup-vault-dev"
      change_grace_days  = 7
      min_retention_days = 14
      max_retention_days = 90
    }
    "backup-vault-qua" = {
      name               = "backup-vault-qua"
      change_grace_days  = 14
      min_retention_days = 30
      max_retention_days = 180
    }
    "backup-vault-prod" = {
      name               = "backup-vault-prod"
      change_grace_days  = 30
      min_retention_days = 90
      max_retention_days = 365
    }
  }
}
```

Ajusta estes valores de acordo com as tuas políticas internas de retenção, compliance e custo.
