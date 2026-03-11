# Contributing

## Workflow
- Create a feature branch from `main`.
- Keep changes small and focused.
- Run Terraform validation commands before opening a PR.
- Open a Pull Request with a clear description and motivation.

## Terraform conventions
- Use `terraform fmt` to format all `.tf` files.
- Use `terraform validate` to catch syntax and basic configuration issues.
- Prefer small, reviewable changes to large refactors.
- Do not change infrastructure semantics without updating documentation and ADRs.

## Pull Request guidelines
- Describe the problem and the proposed change.
- Link to relevant ADRs or create a new ADR when you introduce significant design decisions.
- Add or update documentation under `docs/` when behavior changes.
- Request review from at least one maintainer.
