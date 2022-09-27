resource "aws_codepipeline" "my_codepipeline" {
  name     = "my-codepipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline-bucket-26-09-22.bucket
    type     = "S3"

    #encryption_key {
    # id   = data.aws_kms_alias.s3kmskey.arn
    #type = "KMS"
    #}
  }


  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        #  ConnectionArn    = "aws_codecommit_repository.TF-test-CC.arn"
        RepositoryName = "aws_codecommit_repository.TF-test-CC.repository_name"
        BranchName     = "main"
      }
    }
  }

  #  stage {
  #   name = "Build"


  #   action {
  #     name             = "Build"
  #    category         = "Build"
  #   owner            = "AWS"
  #  provider         = "CodeBuild"
  # input_artifacts  = ["source_output"]
  #output_artifacts = ["build_output"]
  #version          = "1"

  # configuration = {
  #  ProjectName = "test"

  #}
  #}

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["source_output"]
      version         = "1"
      configuration = {
        ApplicationName     = "aws_codedeploy_app.task-application.name"
        DeploymentGroupName = "aws_codedeploy_deployment_group.task-deployment-group.deployment_group_name"

      }



      #configuration = {
      #ActionMode     = "REPLACE_ON_FAILURE"
      #Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
      # OutputFileName = "CreateStackOutput.json"
      # StackName      = "MyStack"
      #  TemplatePath   = "build_output::sam-templated.yaml"
      # }
    }
  }

  depends_on = [aws_instance.TF-task-instance]
}

#resource "aws_codestarconnections_connection" "example" {
# name          = "example-connection"
# provider_type = "GitHub"
#}

resource "aws_s3_bucket" "codepipeline-bucket-26-09-22" {
  bucket = "codepipeline-bucket-26-09-22"
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline-bucket-26-09-22.id
  acl    = "private"
}

resource "aws_iam_role" "codepipeline_role" {
  name = "test-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline-bucket-26-09-22.arn}",
        "${aws_s3_bucket.codepipeline-bucket-26-09-22.arn}/*"
      ]
    }

   ] 
 }
EOF
}

#data "aws_kms_alias" "s3kmskey" {
# name = "alias/myKmsKey"
#}
