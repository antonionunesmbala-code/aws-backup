# Restore testing

Este documento descreve como validar que os backups estão a ocorrer e como executar testes de restore.

## 1. Validar execução de backups

1. Aceder à consola AWS Backup na management account ou conta delegada.
2. Navegar para **Protected resources**.
3. Filtrar por contas, regiões e tags configuradas (por exemplo, a tag `backup_plan`).
4. Confirmar que existem recovery points criados de acordo com os schedules definidos.

## 2. Verificar recovery points

1. Na consola AWS Backup, escolher o Backup Vault adequado.
2. Listar os recovery points.
3. Validar:
   - número de recovery points
   - timestamps
   - tipo de recurso (EBS, RDS, etc.)

## 3. Executar restore de teste

1. Selecionar um recovery point recente.
2. Iniciar operação de restore para um ambiente de teste ou conta não crítica.
3. Usar parâmetros que evitem sobrescrever recursos de produção.
4. Acompanhar o job de restore até conclusão.

## 4. Validar dados restaurados

- Para volumes/EC2:
  - montar o volume restaurado
  - validar integridade de ficheiros e aplicações
- Para bases de dados:
  - verificar se a base de dados arranca corretamente
  - executar queries simples de validação

## 5. Frequência recomendada de testes

- Pelo menos **trimestralmente** em ambientes de produção.
- Após mudanças significativas na arquitetura ou parâmetros de backup.
- Após alterações de permissões (IAM/KMS) relevantes para backup/restore.

## 6. Evidência para auditoria

Recomenda-se guardar:
- registos de jobs de backup e restore
- capturas de ecrã ou exports da consola
- identificadores de recovery points usados em testes
- descrição do cenário de teste e resultados

Estas evidências podem ser arquivadas em sistemas de compliance internos ou anexadas a relatórios de auditoria.
