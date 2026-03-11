# Development

## Ambiente de desenvolvimento

- Ter Terraform instalado na versão especificada em `terraform_backup/versions.tf`.
- Ter acesso a uma conta AWS de teste (idealmente uma OU dedicada a sandboxes).

## Comandos úteis

- `terraform fmt` — formatar os ficheiros `.tf`.
- `terraform validate` — validar a configuração.
- `terraform plan` — pré-visualizar mudanças.

## Fluxo de trabalho sugerido

1. Criar uma branch a partir de `main`.
2. Fazer alterações em pequenos passos, atualizando documentação quando necessário.
3. Executar `terraform fmt` e `terraform validate`.
4. Executar `terraform plan` apontando para um workspace/estado de teste.
5. Abrir Pull Request descrevendo claramente o objetivo da mudança.

## Convenções

- Não alterar a lógica central de backup sem atualizar ADRs relevantes.
- Manter `terraform_backup/backup_locals.tf` como fonte principal de configuração e evitar duplicação de parâmetros.
- Atualizar diagramas em `docs/diagrams/` quando a arquitetura mudar de forma relevante.
