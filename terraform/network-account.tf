module "networking_account" { # Module call names must be unique
  source = "./modules/aft-account-request"

  # All control_tower_parameters' fields below are REQUIRED.
  # Triple check these values before committing the file & ensure spelling is correct.
  control_tower_parameters = {
    AccountEmail              = "aws.networking@sentientdecisionscience.com" # example: aws.account+template@company.com
    AccountName               = "Networking"                                 # example: "Template"
    ManagedOrganizationalUnit = "Infrastructure"                             # example: "Template"
    SSOUserEmail              = "aws.networking@sentientdecisionscience.com" # example: aws.account+template@company.com
    SSOUserFirstName          = "Networking"                                 # example: Template
    SSOUserLastName           = "Admin"                                      # example: Admin"
  }

  account_tags = {
    "managed_by" = "AFT"
  }

  change_management_parameters = {
    # Requester email
    change_requested_by = "edwin.moedano@caylent.com"

    # Update reason any time this file is edited
    change_reason = "Provisioning new Networking account"
  }

  # Custom fields are created as SSM Parameters within the AWS account
  # and are used to apply customizations automatically to the account
  # during the global, account, and account-provisioning customizations stages of the AFT pipeline.
  custom_fields = {
    "enable_s3_block_public_access"   = "true"
    "enable_ebs_encryption"           = "true"
    "enable_iam_user_password_policy" = "true"
    "delete_default_vpcs"             = "true" # Used by the aft-account-provisioning-customizations step function
  }

  # The AFT framework uses the following value to map the created account to
  # its customizations folder in the aft-account-customizations repository.
  account_customizations_name = "accounts/networking-account" # example: accounts/template-account
}
