locals {
  labels = {
    "ci-pass" : {
      description = "Label added by CI for passing checks"
      color       = "00FF00"
    }
  }

  repos_labels = [
    for pair in setproduct(toset(data.github_repositories.all_repos.names), keys(local.labels)) : {
      repository  = pair[0]
      name        = pair[1]
      color       = local.labels[pair[1]].color
      description = local.labels[pair[1]].description
    }
  ]
}

resource "github_issue_label" "repo_labels" {
  for_each = tomap({
    for label in local.repos_labels : "${label.repository}.${label.name}" => label
  })

  repository  = each.value.repository
  name        = each.value.name
  color       = each.value.color
  description = each.value.description
}
