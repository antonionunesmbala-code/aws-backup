# Security

## Objetivo

Descrever os controlos de segurança considerados na solução e os pontos de atenção para operação segura.

## Princípios aplicados

- menor privilégio possível
- centralização da governação
- separação entre definição e execução
- proteção dos recovery points
- encriptação com KMS
- redução de alterações manuais

## Controlos existentes

### IAM Role dedicada
A role distribuída para o AWS Backup é assumida pelo serviço `backup.amazonaws.com`.

Benefícios:
- separação clara de responsabilidades
- redução de dependência de acessos manuais
- padronização entre contas

### Managed policies do AWS Backup
A utilização das managed policies ajuda a alinhar a role com o modelo suportado pela AWS.

### KMS por vault
Cada vault utiliza KMS key dedicada.

Benefícios:
- maior controlo criptográfico
- melhor rastreabilidade
- base para políticas mais restritivas

### Vault Lock
Quando ativado, ajuda a prevenir alterações indevidas ou redução indevida de retenção.

## Riscos a considerar

### Permissões excessivas
As permissões da role devem ser revistas periodicamente para garantir que continuam alinhadas ao princípio do menor privilégio.

### Alterações manuais fora do Terraform
Mudanças diretamente na consola podem criar drift e reduzir confiança operacional.

### Gestão de chaves KMS
Policies KMS mal desenhadas podem impedir restore, backup ou administração legítima.

### Vault Lock
Depois de aplicado, pode introduzir restrições fortes.  
Deve ser ativado com governação e validação prévia.

## Recomendações

- ativar CloudTrail para rastreabilidade
- proteger state do Terraform
- aplicar revisão por pull request
- restringir quem pode aplicar mudanças
- validar políticas KMS
- documentar processo de emergency access
- testar restore regularmente

## Segurança operacional

- validar OUs antes de aplicar
- validar regiões alvo
- validar nomes de vaults e retenções
- guardar evidências de mudança
- usar ambientes de teste antes de produção
