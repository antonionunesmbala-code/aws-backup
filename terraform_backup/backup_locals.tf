locals {


  # ATENÇÃO: ajuste estes valores para o seu contexto.
  # "name" é o nome lógico da Backup Policy na AWS Organizations.
  name             = "org-backup-policy"
  # Nome do IAM Role que será criado nas contas membro (StackSet de role).
  backup_role_name = "backup-operations-role"
  # Tag usada para selecionar recursos a proteger (aplicada nas workloads).
  backup_tag_name  = "backup_plan"

  # ATENÇÃO: região principal onde o backup será gerido.
  # Use aqui a região primária da sua organização (ex.: "eu-west-1").
  backup_region = "eu-south-2"

  # Lista de regiões onde a política será aplicada.
  # Pode expandir para várias regiões, se necessário.
  backup_regions = [local.backup_region]


  # ATENÇÃO: substitua estes valores pelos IDs reais das OUs
  # da sua organização (ex.: ou-xxxx-aaaaaaaa, ou-yyyy-bbbbbbbb).
  target_ou_ids = [
    "ou-xxxx-aaaaaaaa",
    "ou-yyyy-bbbbbbbb",
  ]

  # ATENÇÃO: tags globais apenas de exemplo.
  # Ajuste para refletir o seu ambiente/organização.
  tags = {
    environment = "org"      
    owner       = "platform" 
  }

  # ATENÇÃO: horários, janelas e retenções abaixo são um exemplo.
  # Reveja/ajuste para cumprir os requisitos de negócio e compliance.
  backup_plans_input = {
    DEVELOPMENT = {
      schedule                = "cron(0 5 ? * * *)"
      start_window_minutes    = 60
      complete_window_minutes = 300
      vault_name              = "backup-vault-dev"
      lifecycle = {
        delete_after_days = 35
      }
    }

    QUALITY = {
      schedule                = "cron(0 3 ? * * *)"
      start_window_minutes    = 60
      complete_window_minutes = 300
      vault_name              = "backup-vault-qua"
      lifecycle = {
        delete_after_days = 35
      }
    }

    PRODUCTION = {
      schedule                = "cron(0 1 ? * * *)"
      start_window_minutes    = 60
      complete_window_minutes = 300
      vault_name              = "backup-vault-prod"
      lifecycle = {
        delete_after_days = 90
      }
    }
  }


  # ATENÇÃO: nomes de vault e parâmetros de Vault Lock abaixo são exemplo.
  # Ajuste nomes, períodos de retenção e grace period para o seu cenário.
  vaults = {
    "backup-vault-dev" = {
      name               = "backup-vault-dev"
      change_grace_days  = 30
      min_retention_days = 35
      max_retention_days = 365
    }
    "backup-vault-qua" = {
      name               = "backup-vault-qua"
      change_grace_days  = 30
      min_retention_days = 35
      max_retention_days = 365
    }
    "backup-vault-prod" = {
      name               = "backup-vault-prod"
      change_grace_days  = 30
      min_retention_days = 90
      max_retention_days = 365
    }
  }
  # Diretório onde estão os templates CloudFormation (dentro de terraform_backup).
  cf_dir       = "${path.module}/cloudformation"
  cf_vault_tpl = file("${local.cf_dir}/vault.yaml")
  cf_role_tpl  = file("${local.cf_dir}/role.yaml")


  vaults_per_region = {
    for v in values(local.vaults) :
    lower("${local.backup_region}-${v.name}") => {
      vault  = v
      region = local.backup_region
    }
  }


  all_role_names = toset([
    local.backup_role_name
  ])

  backup_plans = {
    for plan_name, p in local.backup_plans_input :
    plan_name => {
      regions = {
        "@@assign" = local.backup_regions
      }

      rules = {
        plan_name = {
          target_backup_vault_name = {
            "@@assign" = p.vault_name
          }

          schedule_expression = {
            "@@assign" = p.schedule
          }

          start_backup_window_minutes = {
            "@@assign" = tostring(p.start_window_minutes)
          }

          complete_backup_window_minutes = {
            "@@assign" = tostring(p.complete_window_minutes)
          }

          lifecycle = merge(
            {},
            try(p.lifecycle.cold_storage_after_days, null) == null ? {} : {
              move_to_cold_storage_after_days = {
                "@@assign" = tostring(p.lifecycle.cold_storage_after_days)
              }
            },
            {
              delete_after_days = {
                "@@assign" = tostring(p.lifecycle.delete_after_days)
              }
            }
          )
        }
      }

      selections = {
        tags = {
          backup-policy = {
            iam_role_arn = {
              "@@assign" = "arn:aws:iam::$account:role/backup/${local.backup_role_name}"
            }

            tag_key = {
              "@@assign" = local.backup_tag_name
            }

            tag_value = {
              "@@assign" = [plan_name]
            }
          }
        }
      }

      backup_plan_tags = {
        for k, v in local.tags :
        k => {
          tag_key   = { "@@assign" = k }
          tag_value = { "@@assign" = v }
        }
      }
    }
  }
}
