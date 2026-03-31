# AFT Account Request

This repo stores the Account Requests for Control Tower Account Factory for Terraform. This is where you place requests for accounts that you would like provisioned and managed by the AFT solution.

> [!NOTE]
>
> Changes committed to the `main` branch of this repository `trigger` the `ct-aft-account-request` CodePipeline within the AFT Management account.
>
> If **new account requests** are detected during its execution, all stages of the AFT pipeline will be run in sequential order. The AFT pipeline stages are:
>
> 1. `aft-account-request` (this repo)
> 2. `aft-account-provisioning-customizations`
> 3. `aft-global-customizations`
> 4. `aft-account-customizations`
>
> If **no new account requests** are detected during its execution, the `ct-aft-account-request` will only execute changes detected in any existing account request, which does not trigger stages `3` and `4`.

---

## Table of Contents

- [Request a new Account](#request-a-new-account)
  - [Account Request Module Inputs](#account-request-module-inputs)
- [Update Existing Account Request](#update-existing-account-request)
- [Submit Multiple Account Requests](#submit-multiple-account-requests)
- [Account Factory Request Workflow](#account-factory-request-workflow)

---

## Request a new Account

AFT follows a GitOps model for creating and updating AWS Control Tower managed accounts. The Account Request Terraform file should be designed to provide the necessary inputs to trigger the AFT pipeline workflow for account vending. You can reference the [example](template-account.tf).

When account provisioning or updating is completed, the AFT pipeline workflow continues and runs AFT Account Provisioning Framework and Customizations steps.

Git push action will trigger `ct-aft-account-request` AWS CodePipeline in AFT management account to process your account request.

Please follow these instructions:

1. Make sure you have the latest changes of this repository.
2. Navigate to the `aft-account-request/terraform` directory.
3. Create a new file and give it a name. For example: `sandbox-account`.
4. Copy the Terraform code from [template](template-account.tf) into the new file. Change the placeholders ```{{PLACEHOLDER}}``` with your own values, e.g. `account email`, `name`, `OU`, and `SSO` fields.
5. Make sure to exclude the word `template` when setting the name for customizing your account. Feel free to modify other values such as tags and custom fields.
6. Save the changes, push the code and check the progress of the pipeline `aft-account-request` in the AFT-Management console.

> Note: The pipeline will be triggered only with changes in the main branch.

### Account Request Module Inputs

* **module name** must be unique per AWS account request.

* **module source** is the path to Account Request terraform module provided by AFT - this should always be ```source = "./modules/aft-account-request"```

* **control_tower_parameters** captures mandatory inputs listed below to create AWS Control Tower managed account.
  * AccountEmail
  * AccountName
  * ManagedOrganizationalUnit
  * SSOUserEmail
  * SSOUserFirstName
  * SSOUserLastName

   Refer to <https://docs.aws.amazon.com/controltower/latest/userguide/account-factory.html> for more information.

* **account_tags** captures user defined keys and values to tag AWS accounts by required business criteria. Refer to <https://docs.aws.amazon.com/organizations/latest/userguide/orgs_tagging.html> for more information on Account Tags.

* **change_management_parameters** captures inputs listed below. As a customer, you may want to capture the reason for the account request and who initiated the request.
  * change_requested_by
  * change_reason

* **custom_fields** capture custom keys and values. As a customer you may want to collect additional metadata which can be logged with the Account Request and also leveraged to trigger additional processing when vending or updating an account. This metadata can be referenced during account customizations to determine the proper guardrails that should be deployed. For example, an account subject to regulatory compliance could deploy an additional config rule.

* **account_customizations_name** Name of a customer-provided Account Customization to be applied when the account is provisioned.

---

## Update Existing Account Request

You may update AFT provisioned accounts by updating previously submitted Account Requests. Git push action triggers the same Account Provisioning workflow to process account update requests.

AFT supports updating all non control_tower_parameters inputs and ManagedOrganizationalUnit of control_tower_parameters input. The remaining control_tower_parameters inputs cannot be changed.

Please follow these instructions:

1. To add an existing account to the AFT pipeline, please access the Control Tower service in the organization management account and retrieve the necessary account information. If the account is not yet enrolled, please enroll it first before proceeding with the process. For further information check this [link](https://docs.aws.amazon.com/en_us/controltower/latest/userguide//enroll-account.html).

2. Follow the [instructions](#request-a-new-account)

---

## Submit Multiple Account Requests

Although AWS Control Tower Account Factory can process a single request at a time, the AFT pipeline allows you to submit multiple Account Requests and queues all the requests to be processed by AWS Control Tower Account Factory in FIFO order.

You can create an Account Request Terraform file per account or cascade multiple requests in a single Terraform file.

---
