###########################
## Terragrunt Install Linux
###########################
wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.31.10/terragrunt_linux_amd64
mv terragrunt_linux_amd64 terragrunt
sudo chmod +x terragrunt
sudo mv terragrunt /usr/local/bin

TFENV_ARCH=arm64 tfenv install 1.4.6 tfenv use 1.4.6

# Use Prefix AWS_PROFILE=terraform-development if facing profile issues.
terraform init
terraform fmt --check --recursive -diff
terraform validate
terraform plan
terraform destroy
