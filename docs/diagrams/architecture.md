# Diagrams

## Diagrama lógico

```mermaid
flowchart TD
    A[Terraform] --> B[CloudFormation StackSet - IAM Role]
    A --> C[CloudFormation StackSet - Backup Vaults]
    A --> D[AWS Organizations Backup Policy]

    B --> E[Target OUs / Accounts]
    C --> E
    D --> E

    E --> F[AWS Backup Service]
    F --> G[Backup Vaults per Region]
    G --> H[Recovery Points]


    flowchart LR
    A[Management / Delegated Admin Account] --> B[Terraform Execution]
    B --> C[AWS Organizations]
    B --> D[CloudFormation StackSets]
    D --> E[Member Accounts]
    E --> F[IAM Backup Role]
    E --> G[Backup Vault]
    G --> H[KMS Key]

sequenceDiagram
    participant T as Terraform
    participant O as AWS Organizations
    participant S as StackSets
    participant A as Member Accounts
    participant B as AWS Backup

    T->>S: Create role StackSet
    T->>S: Create vault StackSets
    S->>A: Deploy role and vault resources
    T->>O: Create BACKUP_POLICY
    T->>O: Attach policy to target OUs
    O->>B: Apply organizational backup rules
    B->>A: Execute backups using role
    B->>A: Store recovery points in vaults


