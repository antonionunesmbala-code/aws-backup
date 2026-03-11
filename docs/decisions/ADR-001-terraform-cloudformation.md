# ADR-001: Uso combinado de Terraform e CloudFormation

## Estado
Aceite

## Contexto
A solução precisa de gerir recursos organizacionais e também distribuir componentes para múltiplas contas e regiões.

## Decisão
Usar:
- Terraform para orquestração central
- CloudFormation StackSets para distribuição multi-account/multi-region

## Justificativa
Terraform modela bem:
- lógica central
- dependencies
- policy JSON
- attachments

CloudFormation StackSets resolve bem:
- distribuição repetitiva entre contas
- rollout multi-região
- consistência operacional

## Consequências
### Positivas
- separação clara de responsabilidades
- boa escalabilidade
- deployment repetível

### Negativas
- maior complexidade documental
- troubleshooting distribuído por duas camadas