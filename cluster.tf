data "aws_vpc" "default" { default = true }

# Security group that will allow the entire VPC to access Aurora
resource "aws_security_group" "AuroraSG" {
  vpc_id = data.aws_vpc.default.id
  name   = "AuroraSG"
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }
}

# The base cluster + single instance with MySQL 5.7 compatibility
resource "aws_rds_cluster" "AuroraCluster" {
  backtrack_window       = 7200
  cluster_identifier     = "testcluster"
  master_username        = "user"
  master_password        = "Th3Secr3tAur0r4Pa5sw0rd" # USE YOUR OWN PASSWORD or use hashicorp/random provider
  engine                 = "aurora-mysql"
  engine_version         = "5.7"
  vpc_security_group_ids = [aws_security_group.AuroraSG.id]
  skip_final_snapshot    = true
}

resource "aws_rds_cluster_instance" "AuroraInstance" {
  cluster_identifier = aws_rds_cluster.AuroraCluster.id
  instance_class     = "db.t3.small"
  identifier         = "testinstance"
  engine             = "aurora-mysql"
  engine_version     = "5.7"
}

# Store the endpoint in SSM for easy access
resource "aws_ssm_parameter" "AuroraClusterEndpoint" {
  name  = "/testaurora/endpoint"
  type  = "String"
  value = aws_rds_cluster.AuroraCluster.endpoint
}
