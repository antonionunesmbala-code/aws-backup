# ADR-002: Governação por AWS Organizations Backup Policy

## Estado
Aceite

## Contexto
Era necessário garantir consistência de backups em múltiplas contas.

## Decisão
Usar `aws_organizations_policy` do tipo `BACKUP_POLICY` como núcleo lógico da governação.

## Justificativa
Permite:
- centralização
- padronização
- aplicação por OU
- redução de configuração manual

## Consequências
### Positivas
- governance central
- escalabilidade por OU
- consistência entre ambientes

### Negativas
- exige cuidado na modelação da policy
- debugging depende da leitura do JSON final