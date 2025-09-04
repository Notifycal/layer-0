# Layer 0 - Foundational Resources

This repository contains foundational infrastructure resources for the Notifycal project, managed with OpenTofu.

These are resources that don't fit at the environment level, either because their cardinality is at the AWS account level, effectively covering multiple environments (like production and non-production), or because their creation during a typical environment deployment would be too time-consuming.


### [CI](./ci/)

Manages the GitHub organization and CI/CD infrastructure on AWS. This includes the centralized configuration of repositories, branch protection rules, and a secure OIDC authentication flow for GitHub Actions to access different AWS accounts.

For more details, see the [CI README](./ci/README.md).

### [Cloudflare](./cloudflare/)

Manages Cloudflare resources for the `notifycal.com` domain. This includes DNS records, ACM SSL certificate validation, a GitHub Identity Provider (IDP) for developer authentication, Google domain verification, and email redirection rules.

For more details, see the [Cloudflare README](./cloudflare/README.md).