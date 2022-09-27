resource "aws_codecommit_repository" "TF_test_CC" {
  repository_name = var.repository_name
  description     = "This is the sample repo use for code pipeline"
}


output "url" {
  value = aws_codecommit_repository.TF_test_CC.clone_url_http
}

