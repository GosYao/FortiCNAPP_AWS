# FortiCNAPP AWS Integrations

Terraform and helper scripts for integrating AWS environments with
**FortiCNAPP** (Lacework).

Each integration lives in its own subdirectory with its own README.

## Integrations

| Integration | Directory | Description |
|-------------|-----------|-------------|
| **DSPM** | [`DSPM/`](DSPM/) | Data Security Posture Management — deploys DSPM scanners into an AWS account. |

## Prerequisites (all integrations)

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.9
- AWS credentials configured in your environment (env vars, `~/.aws/credentials`,
  AWS SSO, or an instance role)
- A FortiCNAPP (Lacework) account and an **API key + secret**
  (FortiCNAPP console → **Settings → API Keys → Create**)

## Notes

- Terraform **state files are not tracked** in this repo. State is specific to
  your environment and can contain secrets — keep it local or in your own
  remote backend. See `.gitignore`.
- The Terraform templates ship with placeholder values (e.g. a placeholder AWS
  account ID). Replace them with your own before applying.
