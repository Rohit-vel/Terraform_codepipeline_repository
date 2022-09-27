# Terraform_codepipeline_repository
This is repository contains Terraform files of code pipeline.

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

