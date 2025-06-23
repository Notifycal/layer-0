locals {
  # Using objects for the check names so it's not affected by ordering
  repo_status_checks = {
    frontend = {
      actionlint = "actionlint"
      build      = "build"
      tofu       = "tofu"
    }
    backend = {
      actionlint = "actionlint"
      build      = "build"
      tofu       = "tofu"
    }
    shared = {
      actionlint = "actionlint"
      build      = "build"
    }
    static-landing = {
      actionlint = "actionlint"
      build      = "build"
      tofu       = "tofu"
    }
    docs-internal = {
      actionlint = "actionlint"
      tofu       = "plan"
      build      = "build"
    }
    gh-actions = {
      actionlint = "actionlint"
    }
    tofu-module-static-website = {
      tofu = "cd"
    }
    tofu-module-acm-cert = {
      tofu = "cd"
    }
    environments = {
      actionlint = "actionlint"
      tofu       = "dev"
    }
  }
}

resource "github_branch_protection" "this" {
  for_each = var.enable_branch_protection ? toset(local.non_poc_research_repos) : []

  repository_id = each.key
  pattern       = "main"

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 0
  }

  required_status_checks {
    # If the repo isn't defined in the list above, then won't enforce any checks
    contexts = try(toset(values(local.repo_status_checks[each.key])), [])
    strict   = can(toset(values(local.repo_status_checks[each.key])))
  }
}
