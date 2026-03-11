# Costs

## Nota importante

Os custos reais dependem de:
- região
- quantidade de contas
- número de vaults
- volume de dados protegidos
- frequência dos backups
- retenção
- restores executados
- utilização de KMS

Este documento apresenta apenas os principais drivers de custo.

## Principais componentes com custo

### AWS Backup
Custos associados a:
- armazenamento de recovery points
- restores
- cópias entre regiões ou contas, se vierem a ser usadas
- indexação, quando aplicável ao cenário

### AWS KMS
Custos associados a:
- chaves geridas pelo cliente
- pedidos criptográficos
- utilização recorrente da chave pelos vaults

### CloudFormation StackSets
Normalmente o custo direto do CloudFormation tende a ser baixo ou inexistente, mas o impacto operacional existe por propagação multi-conta e multi-região.

### Terraform
Sem custo direto no serviço em si, mas pode existir custo indireto associado ao ambiente de execução e state backend.

### Logs e auditoria
Se forem adicionados no futuro:
- CloudWatch Logs
- CloudTrail
- EventBridge
- SNS / integrações externas

## Drivers principais

### 1. Retenção
Quanto maior a retenção, maior o custo acumulado.

### 2. Número de recovery points
Schedules mais frequentes aumentam o volume armazenado.

### 3. Número de contas e regiões
Mais contas e mais regiões significam mais vaults, mais chaves e maior dispersão operacional.

### 4. Restore
Restores frequentes podem ter impacto direto no custo.

## Boas práticas para controlo de custo

- ajustar retenções por criticidade
- evitar manter development com retenção excessiva
- rever schedules de ambientes não produtivos
- consolidar estratégia regional quando fizer sentido
- acompanhar crescimento mensal do storage
- validar se todos os vaults são realmente necessários

## Estimativa qualitativa

### Desenvolvimento
Custo normalmente mais baixo, desde que:
- retenção seja curta
- frequência seja moderada
- volume de dados seja reduzido

### Quality
Custo intermédio, dependendo da proximidade com produção.

### Produção
Maior custo, devido a:
- retenção mais longa
- maior volume de dados
- maior criticidade
- necessidade potencial de mais cópias e validações

## Recomendação

Para publicação do projeto, este documento deve ser apresentado como visão de custo conceptual, não como pricing oficial.  
Se quiseres, depois posso ajudar-te a montar uma secção com **estimativa mensal por cenário**.