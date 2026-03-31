# ---------------------------------------------------------------------------------------------
# Datasources
# ---------------------------------------------------------------------------------------------

# Retrieving Organization Management Account ID
data "aws_ssm_parameter" "organization_management_account_id" {
  name = "/aft/account/ct-management/account-id"
}

# Retrieving information about the AWS Organization
data "aws_organizations_organization" "current" {
  provider = aws.ct_admin_role
}
