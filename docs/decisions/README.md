# Architecture Decision Records (ADRs)

Este diretório contém as decisões de arquitetura relacionadas com a solução de backups organizacionais.

- `ADR-001-terraform-cloudformation.md` — Uso combinado de Terraform (orquestração) e CloudFormation StackSets (distribuição multi-conta/multi-região).
- `ADR-002-organization-backup-policy.md` — Governação de backups através de AWS Organizations Backup Policy.
- `ADR-003-stacksets-for-distribution.md` — Uso de StackSets para distribuir IAM Role e Backup Vaults.
- `ADR-004-vault-lock-retention.md` — Parametrização de Vault Lock e janelas de retenção por ambiente.

Novas decisões de arquitetura relevantes devem ser documentadas aqui como novos ADRs numerados sequencialmente.
