# Runbook

## Objetivo

Este runbook descreve os procedimentos operacionais para validação, deployment, troubleshooting, rollback e verificação de backups/restores.

---

## 1. Validação antes do deployment

Antes de qualquer `terraform apply`, confirmar:
- AWS Organizations acessível.
- OUs alvo corretas em `terraform_backup/backup_locals.tf` (`target_ou_ids`).
- Permissões disponíveis para gerir Organizations, StackSets, IAM e KMS.
- Templates CloudFormation válidos (`terraform_backup/cloudformation/role.yaml` e `terraform_backup/cloudformation/vault.yaml`).
- Parâmetros e locals revistos em `terraform_backup/backup_locals.tf`.
- Regiões alvo corretas (`backup_region`/`backup_regions`).
- Nomes de vaults e parâmetros de Vault Lock corretos.

Sugere-se executar `terraform validate` como verificação adicional.

---

## 2. Deployment

1. Inicializar o diretório Terraform:

```bash
terraform init
```

2. Rever o plano de execução:

```bash
terraform plan
```

3. Se o plano estiver alinhado com o esperado, aplicar:

```bash
terraform apply
```

4. Guardar o output relevante (incluindo `debug_org_backup_policy_json`) para futura referência/troubleshooting.

---

## 3. Validação pós-deployment

### 3.1 StackSets

Na consola AWS CloudFormation (StackSets):
- Verificar o StackSet da role.
- Verificar os StackSets dos vaults.
- Confirmar que todas as stack instances para as OUs/regiões alvo estão em estado `CURRENT`/`SUCCEEDED`.

### 3.2 IAM Roles nas contas

Em contas alvo (amostra por OU):
- Verificar que a IAM Role de backup foi criada com o nome configurado (`backup_role_name`).
- Confirmar que a trust policy permite `backup.amazonaws.com` assumir a role.

### 3.3 Backup Vaults

Na consola AWS Backup:
- Verificar que os vaults existem nas regiões configuradas.
- Confirmar se os parâmetros de Vault Lock (quando usados) estão de acordo com os valores esperados.

### 3.4 Attachment da policy

Na consola AWS Organizations:
- Verificar que a policy do tipo `BACKUP_POLICY` foi criada.
- Confirmar que está anexada às OUs definidas em `target_ou_ids`.

### 3.5 Execução de backups

Na consola AWS Backup:
- Aguardar pelo menos um ciclo de schedule.
- Verificar recursos protegidos e recovery points criados.

---

## 4. Troubleshooting

### 4.1 Falhas em StackSets

- Verificar eventos da StackSet e das stack instances.
- Identificar problemas de permissões (IAM/KMS) ou quotas.
- Corrigir a causa raiz e re-executar a operação de StackSet.

### 4.2 Policy não aplicada

- Confirmar que o `terraform apply` criou/atualizou a policy.
- Rever o output `debug_org_backup_policy_json` para detetar erros de modelação.
- Verificar na consola AWS Organizations se a policy está anexada às OUs certas.

### 4.3 Backups não a ocorrer

- Verificar se os recursos têm as tags corretas (por exemplo, `backup_plan`).
- Confirmar que a role de backup existe e é assumida pelo serviço.
- Rever CloudWatch Logs/CloudTrail para erros de AWS Backup.

Mais detalhes sobre testes de restore em `docs/restore-testing.md`.

---

## 5. Rollback (high-level)

> Atenção: rollback de políticas de backup e Vault Lock pode ter implicações fortes. Avaliar sempre impacto antes de reverter.

Opções típicas:

- Remover o attachment da policy das OUs alvo.
- Atualizar `backup_plans_input` para reduzir escopo (por exemplo, ambientes não críticos) e voltar a aplicar.
- Ajustar `target_ou_ids` para remover OUs temporariamente.

Alterações em Vault Lock podem não ser reversíveis dependendo da configuração já aplicada.

---

## 6. Verificação de backups

Passos resumidos (ver detalhes em `docs/restore-testing.md`):

1. Na consola AWS Backup, verificar que vaults contêm recovery points.
2. Confirmar timestamps e tipos de recursos de acordo com os planos.
3. Validar que não há jobs de backup com erros recorrentes.

Registar periodicamente estas verificações para auditoria.

---

## 7. Procedimentos de restore

1. Selecionar um recovery point adequado (por exemplo, o mais recente).
2. Iniciar restore para um ambiente de teste ou conta não crítica.
3. Validar integridade dos dados restaurados (aplicações, ficheiros, bases de dados).
4. Documentar o cenário, resultados e eventuais problemas.

Sugere-se testes de restore **regulares** (por exemplo, trimestrais) para ambientes de produção.