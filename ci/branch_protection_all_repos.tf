locals {
  # Using objects for the check names so it's not affected by ordering
  repo_status_checks = {
    backend = {
      build = "build"
      tofu  = "tofu"
    }
    docs-internal = {
      tofu       = "plan"
      build      = "build"
    }
    environments = {
      tofu       = "dev"
    }
    frontend = {
      # postflight = "postflight"
      build = "build"
      tofu  = "tofu"
    }
    gh-actions = {
      actionlint = "actionlint"
    }
    shared = {
      build      = "build"
    }
    static-landing = {
      build      = "build"
      tofu       = "tofu"
    }
    tofu-module-acm-cert = {
      tofu = "cd"
    }
    tofu-module-static-website = {
      tofu = "cd"
    }
    tofu-module-static-website = {
      tofu = "cd"
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
