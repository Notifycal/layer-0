locals {
  # Using objects for the check names so it's not affected by ordering
  repo_status_checks = {
    backend = {
      preflight = "preflight"
      build = "build"
      tofu  = "tofu"
    }
    docs-internal = {
      changes  = "changes"
      tofu       = "plan"
      build      = "build"
    }
    environments = {
      filter-envs = "filter-envs"
      tofu       = "CI/CD: dev"
    }
    frontend = {
      preflight = "preflight"
      # postflight = "postflight"
      build = "build"
      tofu  = "tofu"
    }
    shared = {
      build      = "build"
    }
    static-landing = {
      preflight = "preflight"
      build      = "build"
      tofu       = "tofu"
    }
    tofu-module-acm-cert = {
      tofu = "cd"
    }
    tofu-module-static-website = {
      tofu = "cd"
    }
    tofu-module-aws-slack-notify = {
      tofu = "cd"
    }
  }

  non_automergeable_repos = [
    "gh-actions",
    "layer-0",
    "template-tofu-module",
  ]
}

resource "github_branch_protection" "this" {
  for_each = (var.enable_branch_protection ?
    setsubtract(toset(local.non_poc_research_repos), local.non_automergeable_repos) :
    []
  )

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
