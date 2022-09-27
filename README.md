# Terraform_codepipeline_repository
This is repository contains Terraform files of code pipeline.

# Terraform sample code

you will get all sample code for terraform on below link 

https://registry.terraform.io/providers/hashicorp/aws/latest/docs

There are important command to be used in terraform.

1. terraform init   # To initiate your directory for terraform. 
2. terraform plan   #To see simple output without apply.
3. terraform validate  #to validate your script without run.
4. terraform apply   #To get the output of terraform script.
5. terraform refresh  # To get the latest changes in your local if anything change in script.
6. terraform fmt #To provide sutaible formate to your script.
7. terraform show    # run after terraform refresh to see manual changes.


# If you want to access you terraform created instance from your current machine then provide your public key in pipeline's instance

you will get this public key with command   : ssh-keygen

# Regarding instance.tf

In the instance.tf in key creation part I am used file function which is for metion the key file from outside that instance.tf file
