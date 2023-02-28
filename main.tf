resource "aws_vpc" "alaisah_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "Dev"
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.alaisah_vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Dev_public"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.alaisah_vpc.id
  tags = {
    Name = "Dev_myinternetGW"
  }
}

resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.alaisah_vpc.id
  tags = {
    Name = "dev_public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.publicRT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route_table_association" "public_associations" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.publicRT.id
}

resource "aws_security_group" "allow_tls_sG" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.alaisah_vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["81.134.253.133/32"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls_sG"
  }
}

resource "aws_key_pair" "my_authentication" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/mykeypair.pub")
}

resource "aws_instance" "myinstace" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.my_authentication.id
  vpc_security_group_ids = [aws_security_group.allow_tls_sG.id]
  subnet_id              = aws_subnet.public_subnet.id
  user_data              = file("userdata.tpl")
  tags = {
    Name = "my_ec2_instance"
  }

}


#data sources 


# resource "aws_route_table" "alaisahRT" {
#   vpc_id = aws_vpc.alaisah_vpc.id

#   route {
#     cidr_block = "10.0.1.0/32"
#     gateway_id = aws_internet_gateway.my_igw.id
#   }
#   tags = {
#     Name = "dev_res"
#   }
# }