# CI Infrastructure Management with OpenTofu

This repository contains the Infrastructure as Code (IaC) to manage the GitHub organization and its associated CI/CD resources on AWS, using OpenTofu.

## Purpose

The main goal of this project is to centralize and automate the configuration of the organization's repositories, as well as the necessary support infrastructure for continuous integration and deployment (CI/CD) in an AWS multi-account environment.

## Key Features

- **GitHub Repository Management**: Centralized creation and configuration of repositories, labels, and branch protection rules.
- **Environment-based Configuration**: Applies different configurations for deployable repositories in production (`prod`) and nonproduction (`nonprod`) environments.
- **Secure CI/CD Authentication**: Configures a federated authentication flow using OIDC, allowing GitHub Actions to securely access different AWS accounts without static credentials.

## AWS Multi-Account Architecture

This project is designed to manage resources across a multi-account AWS architecture, typically:
- **Source Account (or Management Account) (`mgmt`)**: A central account that holds shared CI/CD resources, such as the main OIDC role for federation with GitHub.
- **Target Accounts (`prod`, `nonprod`)**: Isolated accounts where applications and services are deployed.

To achieve this, the OpenTofu configuration defines multiple instances of the AWS `provider`, each with a specific `alias`. Resources are associated with a specific account by specifying the corresponding provider, for example: `provider = aws.prod`. If no provider is defined in a resource, it defaults to the default provider (the one without `alias`).

## CI Authentication Flow (GitHub Actions -> OIDC -> AWS)

To eliminate the need to store AWS secrets (like `AWS_ACCESS_KEY_ID`) in GitHub, a federated authentication flow with OIDC (OpenID Connect) is used. The process is as follows:

1.  **Trigger in GitHub Actions**: A workflow is initiated in a repository (e.g., by a `push` to the `main` branch).

2.  **OIDC Token Request**: The workflow requests a JSON Web Token (JWT) from GitHub, which acts as the OIDC Identity Provider. This token contains information about the execution context (repository, branch, etc.).

3.  **Assume Role in `mgmt` Account**: The workflow uses the JWT to authenticate against AWS by calling `sts:AssumeRoleWithWebIdentity`. The target is an IAM role in the **`mgmt`** account (defined in `iam_oidc_role.tf`).
    - This role has a trust policy that only accepts tokens from GitHub and validates attributes like the repository name and branch, ensuring that only authorized workflows can use it.

4.  **Obtain Temporary Credentials**: If the validation is successful, AWS STS returns temporary credentials for the role in the `mgmt` account. This role has very limited permissions, primarily the ability to assume other roles (`sts:AssumeRole`).

5.  **Assume Role in `prod`/`nonprod` Account (Cross-Account Assume Role)**: Using the temporary credentials from the previous step, the workflow makes a second `sts:AssumeRole` call. This time, the target is a role in the destination account (`prod` or `nonprod`).
    - This destination role trusts the OIDC role from the `mgmt` account and contains the effective permissions to deploy or modify application resources in that specific environment.

This double-hop mechanism (`GitHub -> mgmt -> prod/nonprod`) ensures least-privilege access, auditability, and a clean separation between environments, drastically improving CI/CD security.
