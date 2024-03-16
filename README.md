# infra



## Cloud providers

- [Supabase](https://supabase.com)
- AWS

## Stacks


## Setup

1. Install [tofuutils/tenv](https://github.com/tofuutils/tenv).

**TODO**: Cloning the repo from scratch (Sergio). Use tenv to install Tofu and TG versions relying on the existing files

1. Create a Supabase [access token](https://supabase.com/dashboard/account/tokens).
1. `export TF_VAR_supabase_access_token=<redacted>`
1. Run `tg init` from the stack folder. Then run `tg plan/apply` 


You might also want to install the `supabase` [CLI tool](https://supabase.com/docs/guides/cli/getting-started) and its [autocompletion](https://supabase.com/docs/reference/cli/supabase-completion).
