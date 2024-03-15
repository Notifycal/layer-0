terraform {
  backend "local" {
    # TODO: Where do we store the state? AWS?
    path = ".terraform/state/terraform.tfstate"
  }
}

provider "supabase" {
  access_token = file("${path.cwd}/access-token")
}

terraform {
  required_providers {
    supabase = {
      source  = "supabase/supabase"
      version = "~> 1.0"
    }
  }
}