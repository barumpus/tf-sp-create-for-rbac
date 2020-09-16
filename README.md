# Terraform AzureAD / AzureRM RBAC Example

**WARNING:** 
    This example creates a service principal (sp) with 
    **Contributor** rights to the default subscription.

Create a basic Application and Service Principal and then assign a role of Contributor to the default subscription.

This mimics the behaviour of `az ad sp create-for-rbac --name ${var.sp_name}` but allows for an expiration set in days (var.sp_days) rather than years.

Note the use of AzureRM resources for subscription data and role assignment.

To view the generated password after running `terraform apply`, use `terraform output client_secret`.

**WARNING:** The Application password will be persisted to state.

Note: 
    this is based, on and hardly different from,
    https://github.com/terraform-providers/terraform-provider-azuread/tree/master/examples/create-for-rbac


```bash
az login --use-device-code
az ad signed-in-user show
SP_NAME=tf-cloud-sp
terraform apply -input=false -var warning=ok -var sp_name=$SP_NAME -auto-approve
terraform output client_secret

export ARM_CLIENT_ID=$(terraform output client_id)
export ARM_CLIENT_SECRET=$(terraform output client_secret)
export ARM_SUBSCRIPTION_ID=$(terraform output subscription_id)
export ARM_TENANT_ID=$(terraform output tenant_id)
env | grep -i arm

# at this point "terraform this" and "terraform that" that will use the env variables

# prove the credentials work but are a tiny bit limited in scope
az logout
az ad signed-in-user show
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET -t $ARM_TENANT_ID
[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "3e74cb79-76e5-497a-a1e9-b6051d41f548",
    "id": "beecc202-17ce-4fa7-82bf-22ef6d0c9113",
    "isDefault": true,
    "managedByTenants": [],
    "name": "Visual Studio Enterprise Subscription",
    "state": "Enabled",
    "tenantId": "3e74cb79-76e5-497a-a1e9-b6051d41f548",
    "user": {
      "name": "796bb317-d6ba-4310-9c64-b58ace09b9ed",
      "type": "servicePrincipal"
    }
  }
]
az ad sp list # should report "insufficient privileges to completes the operation"

export ARM_CLIENT_ID=
export ARM_CLIENT_SECRET=
export ARM_SUBSCRIPTION_ID=
export ARM_TENANT_ID=

az login --use-device-code
az ad app list --filter "startswith(displayName, '$SP_NAME')" --query "[].{appId:appId, displayName:displayName}" -o table
az ad app delete --id ...

terraform destroy -input=false -var warning=ok -var sp_name=whatever -auto-approve
```
