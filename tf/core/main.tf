# There is no remote state backend for the resources defined in this project.
# TODO: Assess if we could/should use one instead of committing the tfstate file.

# Lets make the local state explicit and remind contributors to commit changes
terraform {
  backend "local" {
    path = "./local_commit-me.tfstate"
  }
}
