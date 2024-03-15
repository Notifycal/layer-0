# infra





## Cloud providers

- [Supabase](https://supabase.com)


## Stacks



## Setup

1. Install [tofuutils/tenv](https://github.com/tofuutils/tenv).
2. Run `tenv tofu install` from the root folder.
3. Verify with `tofu --version`. Setup autocomplete with `tofu -install-autocomplete`.
4. Create a Supabase [access token](https://supabase.com/dashboard/account/tokens).
5. Paste the token into a file named `access-token` in the root folder.
6. Run `init` from the root folder: `tofu -chdir=supabase-auth init`.
7. Run `plan` from the root folder: `tofu -chdir=supbase-auth plan`.
8. (Optional) You might want to define an ephemeral alias while working on a specific stack: `alias tofu="tofu -chdir=<stack-name>"`. You might even want to do this to keep typing `tf` in the console.

```
$ tofu -chdir=supabase-auth init
$ tofu -chdir=supabase-auth plan

```


You might also want to install the `supabase` [CLI tool](https://supabase.com/docs/guides/cli/getting-started) and its [autocompletion](https://supabase.com/docs/reference/cli/supabase-completion).
