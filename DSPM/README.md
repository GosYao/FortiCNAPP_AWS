# FortiCNAPP AWS DSPM

Deploy FortiCNAPP (Lacework) **Data Security Posture Management (DSPM)**
scanners into an AWS account.

There are two ways to deploy, both using the same upstream Terraform module
([`lacework/dspm/aws`](https://registry.terraform.io/modules/lacework/dspm/aws)):

1. **[Interactive script](#option-1-interactive-script)** — `deploy-dspm-aws.sh`
   prompts for inputs, sets up credentials, and runs Terraform for you.
2. **[Terraform directly](#option-2-terraform-directly)** — edit the files in
   [`terraform/`](terraform/) and run Terraform yourself.

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.9
- AWS credentials for the **target account** configured in your environment.
  Verify with:
  ```bash
  aws sts get-caller-identity --query Account --output text
  ```
- A FortiCNAPP API key + secret (FortiCNAPP console → **Settings → API Keys → Create**;
  this downloads a JSON file containing `keyId` and `secret`).
- Your **12-digit AWS account ID** — the account where scanners will be deployed.

---

## Option 1: Interactive script

```bash
cd DSPM
./deploy-dspm-aws.sh
```

The script will:

1. Prompt for the integration name, regions, AWS account ID, and your FortiCNAPP
   account/API key/secret.
2. **Verify the FortiCNAPP credentials** against the API before writing anything.
3. Merge a `[forticnapp]` profile into `~/.lacework.toml` (other profiles are
   preserved; the file is chmod `600`).
4. Generate `main.tf` and `version.tf`, then run `terraform init` and, after a
   confirmation prompt, `terraform apply`.

Environment toggles:

- `SKIP_AUTH_CHECK=1` — skip the pre-flight FortiCNAPP credential test.

---

## Option 2: Terraform directly

```bash
cd DSPM/terraform
```

1. **Set up the FortiCNAPP (lacework) provider credentials.** Create
   `~/.lacework.toml`:

   ```toml
   [forticnapp]
     account = "YOUR_ACCOUNT"     # the <account> in <account>.lacework.net
     api_key = "YOUR_API_KEY"
     api_secret = "YOUR_API_SECRET"
     version = 2
   ```
   ```bash
   chmod 600 ~/.lacework.toml
   ```

2. **Edit `main.tf`** and set:
   - `region` in the `aws` provider block (your primary region)
   - `scanning_account_id` — your 12-digit AWS account ID (replace the placeholder `123456789012`)
   - `regions` — the regions to deploy scanners to
   - `lacework_integration_name` — the name shown in FortiCNAPP (optional)

3. **Apply:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

---

## Module inputs reference

| Input | Required | Default | Notes |
|-------|----------|---------|-------|
| `regions` | **yes** | — | List of AWS region codes, e.g. `["us-east-1"]` |
| `scanning_account_id` | **yes** | — | 12-digit AWS account ID |
| `lacework_integration_name` | no | `aws-dspm` | Integration name in FortiCNAPP |
| `scan_frequency_hours` | no | `null` → set to `24` | Allowed: 24, 72, 168, 720 |

> **Note:** the module's default `scan_frequency_hours` is `null`, which fails
> its own validation — always set it explicitly. Both deployment options here
> set it to `24`.

See the [module documentation](https://registry.terraform.io/modules/lacework/dspm/aws/latest)
for the full list of optional inputs (ECS task sizing, datastore filters, tags, etc.).

---

## A note on Terraform state

`terraform apply` creates local state (`terraform.tfstate`) that is **specific to
your environment and may contain secrets**. It is intentionally **not** tracked
in this repo (see the root `.gitignore`). Keep it local, or configure your own
[remote backend](https://developer.hashicorp.com/terraform/language/backend).
