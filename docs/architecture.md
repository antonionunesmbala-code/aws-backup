
---

# 2) `docs/architecture.md`

```md
# Architecture

## Visão geral

Esta solução implementa uma arquitetura centralizada de backup para um ambiente AWS Organizations.  
O objetivo é permitir que as definições de backup sejam governadas a partir de um ponto central, mantendo consistência entre contas, OUs e regiões.

## Princípios da arquitetura

- **Centralização da governação**
- **Distribuição automatizada**
- **Consistência entre ambientes**
- **Separação entre orquestração e provisioning**
- **Capacidade de crescimento por região e por OU**

## Camadas da solução

### 1. Camada de orquestração
Implementada em Terraform.

Responsabilidades:
- definir a política organizacional
- criar attachments da policy às OUs
- criar StackSets
- expor outputs de debug

### 2. Camada de distribuição
Implementada com CloudFormation StackSets.

Responsabilidades:
- propagar a IAM Role necessária ao AWS Backup
- propagar os Backup Vaults pelas regiões definidas
- permitir rollout consistente em múltiplas contas

### 3. Camada de proteção
Implementada por:
- AWS Backup Policy
- Backup Vaults
- KMS Keys
- Vault Lock

Responsabilidades:
- retenção
- schedules
- isolamento lógico dos backups
- enforcement de janelas mínimas e máximas

## Componentes

### AWS Organizations Policy
A policy do tipo `BACKUP_POLICY` é o núcleo lógico da solução.  
Ela define:
- planos por ambiente
- janelas de retenção
- agendamentos
- seleção organizacional dos backups

### IAM Role
A role criada via `role.yaml` é assumida por `backup.amazonaws.com` e fornece as permissões necessárias para execução das operações de backup.

### Backup Vaults
Os vaults são distribuídos via `vault.yaml` e suportam:
- armazenamento de recovery points
- encriptação com KMS
- configuração opcional de Vault Lock

### KMS
Cada vault possui uma chave dedicada, permitindo maior controlo sobre proteção e auditoria.

## Ambientes lógicos

A modelação atual distingue três perfis:
- DEVELOPMENT
- QUALITY
- PRODUCTION

Cada um pode ter:
- schedule próprio
- retenção própria
- criticidade distinta

## Fluxo de deployment

1. Terraform lê locals e parâmetros
2. Terraform cria StackSet da role
3. Terraform cria StackSets dos vaults
4. StackSets distribuem recursos nas contas/OU/regiões
5. Terraform cria a backup policy
6. Terraform faz attachment da policy às OUs alvo
7. AWS Backup aplica a política nas contas abrangidas

## Benefícios da arquitetura

- Redução de configuração manual
- Escalabilidade organizacional
- Padronização de retenção
- Facilidade de auditoria
- Base sólida para compliance

## Riscos e dependências

- Dependência de permissões elevadas
- Dependência de AWS Organizations bem estruturado
- Dependência do sucesso dos StackSets antes da policy
- Custos associados a retenção prolongada, cópias e restores