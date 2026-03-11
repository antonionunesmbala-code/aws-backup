# Configuration

Este documento descreve os principais parâmetros definidos em `terraform_backup/backup_locals.tf` e o seu impacto operacional.

## `name`
- **Descrição**: identificador lógico da política organizacional de backup.
- **Formato**: string simples (por exemplo, `org-backup-policy`).
- **Impacto**: usado para nomear a Organizations Backup Policy e alguns recursos relacionados; mudar este valor pode criar uma nova policy em vez de atualizar a existente.

## `backup_role_name`
- **Descrição**: nome da IAM Role usada pelo serviço AWS Backup nas contas membro.
- **Formato**: string (por exemplo, `backup-operations-role`).
- **Impacto**: deve corresponder ao `RoleName` distribuído pelos StackSets; usado na construção do ARN em `backup_plans`.

## `backup_tag_name`
- **Descrição**: chave de tag usada para selecionar recursos a incluir nos planos de backup.
- **Formato**: string (por exemplo, `backup_plan`).
- **Impacto**: recursos que tiverem esta tag com valores apropriados serão alvo dos planos definidos; naming inconsistente reduz cobertura.

## `backup_region` e `backup_regions`
- **Descrição**: `backup_region` é a região principal; `backup_regions` é a lista de regiões usadas na policy.
- **Formato**: `backup_region` como string AWS Region (ex: `eu-south-2`); `backup_regions` como lista de strings.
- **Impacto**: controla onde os backups são efetuados e onde os vaults são criados; alterar pode implicar recriação de recursos e redistribuição.

## `target_ou_ids`
- **Descrição**: lista de Organizational Unit IDs onde a policy e os StackSets serão aplicados.
- **Formato**: lista de IDs no formato `ou-xxxx-yyyyyyyy`.
- **Impacto**: determina o conjunto de contas abrangidas; OUs erradas podem incluir ou excluir contas indevidamente.

## `tags`
- **Descrição**: mapa de tags aplicadas a recursos criados por Terraform e StackSets.
- **Formato**: mapa `key = value`.
- **Impacto**: usado para governação, billing e auditoria; tags consistentes facilitam reporting.

## `backup_plans_input`
- **Descrição**: definição de planos de backup por "ambiente lógico" (por exemplo, DEVELOPMENT, QUALITY, PRODUCTION).
- **Formato**: mapa onde cada chave é o nome do plano e o valor contém:
  - `schedule` (cron Expression da AWS)
  - `start_window_minutes`
  - `complete_window_minutes`
  - `vault_name`
  - `lifecycle.delete_after_days` e opcionalmente `lifecycle.cold_storage_after_days`
- **Impacto**: controla frequência, janelas de execução e retenção dos backups; alterações podem ter impacto forte em custos e requisitos de compliance.

## `vaults`
- **Descrição**: configuração dos Backup Vaults e respetivos parâmetros de Vault Lock.
- **Formato**: mapa onde cada chave é o nome do vault e o valor inclui:
  - `name`
  - `change_grace_days`
  - `min_retention_days`
  - `max_retention_days`
- **Impacto**:
  - controla o nome efetivo dos vaults
  - define janelas mínima e máxima de retenção aplicadas via Vault Lock
  - alterações podem ser restritas ou irreversíveis após lock; devem ser planeadas cuidadosamente.

Para mais detalhes sobre a arquitetura e o fluxo de deployment, ver `docs/architecture.md` e `docs/diagrams/architecture.md`.
