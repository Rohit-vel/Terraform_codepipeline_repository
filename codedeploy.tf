resource "aws_iam_role" "code-deploy-role" {
  name = "code-deploy-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = var.codedeploy_role_policy_arn
  role       = aws_iam_role.code-deploy-role.name
}

resource "aws_codedeploy_app" "task-application" {
  name = var.applicatiin_name
}

#resource "aws_sns_topic" "example" {
# name = "example-topic"
#}

resource "aws_codedeploy_deployment_group" "task-deployment-group" {
  app_name              = aws_codedeploy_app.task-application.name
  deployment_group_name = var.deployment_group
  service_role_arn      = aws_iam_role.code-deploy-role.arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "TF-task-instance"
    }

    ec2_tag_filter {
      key   = "filterkey2"
      type  = "KEY_AND_VALUE"
      value = "filtervalue"
    }

  }


  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }
}
# trigger_configuration {
#trigger_events     = ["DeploymentFailure"]
#trigger_name       = "example-trigger"
# trigger_target_arn = aws_sns_topic.example.arn
#}

#  auto_rollback_configuration {
#   enabled = true
#  events  = ["DEPLOYMENT_FAILURE"]
#}

#alarm_configuration {
# alarms  = ["my-alarm-name"]
#enabled = true
#}
