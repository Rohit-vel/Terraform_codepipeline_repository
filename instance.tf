resource "aws_instance" "TF-task-instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.tf-ec2-kp.key_name
  vpc_security_group_ids = ["${aws_security_group.ec2-sg.id}"]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile_1.name
  user_data              = <<-EOF

                         #!/bin/bash
              sudo apt-get update
              sudo apt install apache2 -y && apt install git -y 
              sudo sudo apt-get remove docker docker-engine docker.io
              sudo apt install docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo systemctl start apache2
              sudo systemctl enable apache2
              sudo systemctl start git
              sudo systemctl enable git
              echo “ <h1>This is project of terraform  $(hostname -f) </h1> ” > /var/www/html/index.html
              cd /mnt
	      touch rohit.txt
              git init
              git clone aws_codecommit_repository.TF_test_CC.clone_url_http
              echo 'hello world' > touch.txt
              git commit -a -m 'init master'
              git push -u origin master

EOF

  tags = {
    Name = "TF-task-instance"
  }
}

resource "aws_key_pair" "tf-ec2-kp" {
  key_name   = "tf-ec2-kp"
  public_key = file("${path.module}/id_rsa.pub")

}


resource "aws_security_group" "ec2-sg" {
  name        = "ec2-sg"
  description = "Allow ec2 inbound traffic"

  dynamic "ingress" {
    for_each = [22, 80, 443, 3306]
    iterator = port

    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

    }
  }


  tags = {
    Name = "ec2-sg"
  }
}






############################## IAM ROLE ################################################

resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2_policy"
  role = aws_iam_role.ec2_cc_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "CodeCommit:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "ec2_cc_role" {
  name = "ec2_cc_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile_1" {
  name = "ec2_profile_1"
  role = aws_iam_role.ec2_cc_role.name
}
