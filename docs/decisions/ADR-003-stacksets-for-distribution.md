# ADR-003: Uso de StackSets para distribuição da role e vaults

## Estado
Aceite

## Contexto
Os recursos precisavam de existir em várias contas e regiões.

## Decisão
Distribuir IAM Role e Backup Vaults através de CloudFormation StackSets.

## Justificativa
- reduz esforço manual
- suporta ambientes organizacionais
- melhora consistência do provisioning

## Consequências
### Positivas
- rollout centralizado
- menos erro manual
- expansão facilitada

### Negativas
- troubleshooting pode exigir análise por stack instance
- falhas parciais precisam de acompanhamento