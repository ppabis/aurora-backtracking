# Easily find the latest Amazon Linux in SSM
data "aws_ssm_parameter" "AL2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-arm64"
}

# Role for the instance with SSM access - Parameter Store + Session Manager
resource "aws_iam_role" "SSMInstance" {
  name               = "SSMInstanceRole"
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [ {
        "Action": "sts:AssumeRole",
        "Principal": { "Service": [ "ec2.amazonaws.com" ] },
        "Effect": "Allow",
        "Sid": ""
      } ]
  }
  EOF
}

resource "aws_iam_instance_profile" "SSMInstance" {
  name = "SSMInstanceRole"
  role = aws_iam_role.SSMInstance.name
}

resource "aws_iam_role_policy_attachment" "SSMInstance" {
  role       = aws_iam_role.SSMInstance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Allow any outbound connections from the instance - package installation and Aurora access
resource "aws_security_group" "myinstance" {
  name        = "TestInstanceSG"
  description = "TestInstanceSG"
  vpc_id      = data.aws_vpc.default.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Amazon Linux instance with public IP, SSM permissions and install MariaDB client on first boot
resource "aws_instance" "myinstance" {
  instance_type               = "t4g.nano"
  ami                         = data.aws_ssm_parameter.AL2023.value
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.SSMInstance.name
  vpc_security_group_ids      = [aws_security_group.myinstance.id]
  user_data                   = <<-EOF
  #!/bin/bash
  yum update -y
  yum install -y mariadb105
  EOF
}
