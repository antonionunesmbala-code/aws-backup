# ADR-004: Uso de Vault Lock e retenção parametrizada

## Estado
Aceite

## Contexto
Era necessário garantir proteção adicional sobre os recovery points e controlo das janelas de retenção.

## Decisão
Usar parâmetros de:
- grace period
- minimum retention
- maximum retention
- configuração opcional de Vault Lock

## Justificativa
Permite adaptar proteção e compliance por ambiente sem reescrever templates.

## Consequências
### Positivas
- maior controlo
- proteção reforçada
- flexibilidade operacional

### Negativas
- alterações podem tornar-se mais restritas após aplicação
- requer planeamento cuidadoso