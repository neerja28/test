package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestWebAppFtpState1(t *testing.T) {

	terraformOptionsOne := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		TerraformDir: "../tests",
		VarFiles:     []string{"WebAppFTPDeployFtpsonly.Auto.tfvars"},
	})

	defer terraform.Destroy(t, terraformOptionsOne)
	terraform.InitAndApply(t, terraformOptionsOne)

	// Run `terraform output` to get the values of output variables and check they have the expected values.
	// expectedFtpStatusThree := terraform.Output(t, terraformOptions, "WebApp_Ftp_status_test_three")
}

func TestWebAppFtpState2(t *testing.T) {

	terraformOptionsTwo := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../tests",
		VarFiles:     []string{"WebAppFTPDeployDisabled.Auto.tfvars"},
	})

	//Run `terraform output` to get the values of output variables and check they have the expected values.
	//expectedFtpStatusThree := terraform.Output(t, terraformOptions, "WebApp_Ftp_status_test_three")

	defer terraform.Destroy(t, terraformOptionsTwo)
	terraform.InitAndApply(t, terraformOptionsTwo)
}

func TestWebAppFtpState3(t *testing.T) {

	terraformOptionsThree := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../tests",
		VarFiles:     []string{"WebAppFTPDeployAllowed.Auto.tfvars"},
	})

	if _, output := terraform.InitAndApplyE(t, terraformOptionsThree); output == nil {
		assert.Contains(t, output, "AA_POLICY_TEST: Enforce Web App ftp state to use ftps_only or disabled")
	}
	defer terraform.Destroy(t, terraformOptionsThree)
}

func TestWebAppFtpState4(t *testing.T) {

	terraformOptionsFour := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../tests",
		VarFiles:     []string{"WebAppDisabledAllowedModified.Auto.tfvars"},
	})
	defer terraform.Destroy(t, terraformOptionsFour)
	terraform.InitAndApply(t, terraformOptionsFour)

	terraformOptionsFourModify := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../tests",
		VarFiles:     []string{"WebAppModifiedDisabledAllowed.Auto.tfvars"},
	})
	if _, output := terraform.InitAndApplyE(t, terraformOptionsFourModify); output == nil {
		assert.Contains(t, output, "AA_POLICY_TEST: Enforce Web App ftp state to use ftps_only or disabled")
	}
	terraform.Destroy(t, terraformOptionsFourModify)

}

func TestWebAppFtpState5(t *testing.T) {

	terraformOptionsFive := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		TerraformDir: "../tests",
		VarFiles:     []string{"WebAppFtpsAllowedModified.Auto.tfvars"},
	})
	terraform.InitAndApply(t, terraformOptionsFive)

	terraformOptionsFiveModify := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		TerraformDir: "../tests",
		VarFiles:     []string{"WebAppModifiedFtpsAllowed.Auto.tfvars"},
	})
	if _, output := terraform.InitAndApplyE(t, terraformOptionsFiveModify); output == nil {
		assert.Contains(t, output, "AA_POLICY_TEST: Enforce Web App ftp state to use ftps_only or disabled")
	}

	terraform.Destroy(t, terraformOptionsFive)
	terraform.Destroy(t, terraformOptionsFiveModify)
}
