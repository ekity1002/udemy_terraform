resource "aws_instance" "this" {
  ami           = "ami-0eba6c58b7918d3a1"
  instance_type = "t2.micro"

  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.this.id]
  associate_public_ip_address = true

  user_data                   = file("${path.module}/user_data.sh")
  user_data_replace_on_change = true

  tags = {
    Name = "udemy-terraform-ec2"
  }
}

resource "random_id" "this" {
  byte_length = 8
}

### data source #####
data "aws_subnet" "this" {
  # aws_subnet　aws上の subnet を指定。ここには具体的なawsのリソース(EC2, VPCなど)を指定
  # this: 指定したリソースの名前をつける. ここではthisと名付ける
  # id = var.subnet_id: どのサブネットの情報を取得するかをIDで指定している. var.subnet_id ec2moduleで変数定義されているもの。はすでに作成された
  id = var.subnet_id
}
#########

resource "aws_security_group" "this" {
  vpc_id      = data.aws_subnet.this.vpc_id
  name        = "udemy-terraform-ec2-sg-${random_id.this.hex}"
  description = "Allow HTTP and SSH inbound traffic"
}

resource "aws_security_group_rule" "ssh" {
  count             = var.allow_ssh ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

## ALB 飲みからアクセスできるようにコメントアウト
# resource "aws_security_group_rule" "http" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks       = ["106.152.157.78/32"]
#   security_group_id = aws_security_group.this.id
# }

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}
