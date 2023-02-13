package ShareInfraTest

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformSharedEnvironment(t *testing.T) {
	// subscriptionID is overridden by the environment variable "ARM_SUBSCRIPTION_ID"
	subscriptionID := ""
	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "../.",
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables and check they have the expected values.
	acr_name := terraform.Output(t, terraformOptions, "acr_name")
	rg_name := terraform.Output(t, terraformOptions, "rg_name")
	rg_exists := azure.ResourceGroupExists(t, rg_name, subscriptionID)
	acr_exists := azure.ContainerRegistryExists(t, acr_name, rg_name, subscriptionID)
	assert.True(t, rg_exists, "Resource Group does not exist")
	assert.True(t, acr_exists, "Acr does not exist")
}
