resource "aws_instance" "laba" {
  ami = "ami-0c83cb1c664994bbd"
  instance_type = "t3.micro"
  key_name = "aws"
  tags = {
    Name = "laba"
  }
  security_groups = [
    aws_security_group.laba.name
  ]
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c83cb1c664994bbd"
  instance_type = "t3.micro"
  key_name      = "aws"
  vpc_security_group_ids = [aws_security_group.web_server.id]
  tags = {
    Name = "web_server"
  }
  security_groups = [
    aws_security_group.web_server.name
  ]
}

resource "aws_instance" "app" {
  ami           = "ami-0c83cb1c664994bbd"
  instance_type = "t3.micro"
  key_name      = "aws"
  vpc_security_group_ids = [aws_security_group.app.id]
  tags = {
    Name = "app"
  }
   security_groups = [
    aws_security_group.app.name
  ]
}

resource "aws_route53_record" "web_server_a" {
  zone_id = aws_route53_zone.subdomain.zone_id
  name    = "web.aws.alotoflords.pp.ua"
  type    = "A"
  ttl     = 300
  records = [aws_instance.web_server.public_ip]
}

resource "aws_route53_record" "app_a" {
  zone_id = aws_route53_zone.subdomain.zone_id
  name    = "app.aws.alotoflords.pp.ua"
  type    = "A"
  ttl     = 300
  records = [aws_instance.app.public_ip]
}

resource "aws_security_group" "laba" {
}

resource "aws_security_group" "web_server" {
}

resource "aws_security_group" "app" {
}


resource "aws_vpc_security_group_ingress_rule" "allow-ssh-from-all" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.laba.id
  from_port = 22
  to_port = 22
  cidr_ipv4 = "0.0.0.0/0"
}


resource "aws_vpc_security_group_ingress_rule" "web_ssh" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.web_server.id
  from_port = 22
  to_port = 22
  cidr_ipv4 = "0.0.0.0/0"
}

#
resource "aws_vpc_security_group_ingress_rule" "web_http" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.web_server.id
  from_port = 80
  to_port = 80
  cidr_ipv4 = "0.0.0.0/0"
}


resource "aws_vpc_security_group_ingress_rule" "web_https" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.web_server.id
  from_port = 443
  to_port = 443
  cidr_ipv4 = "0.0.0.0/0"
}


resource "aws_vpc_security_group_egress_rule" "web_egress" {
  security_group_id = aws_security_group.web_server.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}


resource "aws_vpc_security_group_ingress_rule" "app_ssh" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.app.id
  from_port = 22
  to_port = 22
  cidr_ipv4 = "0.0.0.0/0"
}


resource "aws_vpc_security_group_ingress_rule" "app_8080" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.app.id
  from_port = 8080
  to_port = 8080
  referenced_security_group_id = aws_security_group.web_server.id
}


resource "aws_vpc_security_group_egress_rule" "app_egress" {
  security_group_id = aws_security_group.app.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}


resource "aws_vpc_security_group_egress_rule" "laba_egress" {
  security_group_id = aws_security_group.laba.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_route53_zone" "subdomain" {
  name = "aws.alotoflords.pp.ua"
}

output "instance-laba-public-ip" {
  value = aws_instance.laba.public_ip
}

output "instance-web-public-ip" {
  value = aws_instance.web_server.public_ip
}

output "instance-app-public-ip" {
  value = aws_instance.app.public_ip
}