provider "aws" {
  # Primary region. The aws provider uses whatever credentials are already
  # configured in your environment (env vars, ~/.aws/credentials, SSO, or an
  # instance role). Make sure those credentials are for the same account as
  # scanning_account_id below.
  region = "us-east-1"
}

# Pinned to the [forticnapp] profile in ~/.lacework.toml, so this works in any
# shell (no need to export LW_PROFILE before running terraform manually).
# See the README for how to create that profile.
provider "lacework" {
  profile = "forticnapp"
}

module "lacework_aws_dspm" {
  source  = "lacework/dspm/aws"
  version = "~> 0.3"

  # Name of the Lacework cloud account integration.
  lacework_integration_name = "aws-dspm"
  # Regions to deploy scanners to.
  regions                   = ["us-east-1"]
  # AWS account ID to deploy DSPM within. Replace with your 12-digit account ID.
  scanning_account_id       = "123456789012"
  # Scan interval in hours (allowed: 24, 72, 168, 720). The module's default is
  # null, which fails its own validation, so set it explicitly.
  scan_frequency_hours      = 24
}
