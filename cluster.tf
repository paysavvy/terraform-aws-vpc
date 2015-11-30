#Amazon ECS-Optimized Amazon Linux AMI

resource "aws_instance" "gastown-private-services" {
  count = 1
  ami = "${var.containers_ami}"
  instance_type = "t2.large"
  subnet_id = "${aws_subnet.us-west-2b-private.id}"
  iam_instance_profile = "ecsInstanceRole"
  associate_public_ip_address = false
  key_name = "${var.aws_key_name}"
  security_groups = [
    "${aws_security_group.gastown-private-services.id}",
  ]
  tags {
    Name = "gastown-private-services"
    Env = "${var.environment}"
  }
}

resource "aws_security_group" "gastown-private-services" {
  name = "gastown-private"
  description = "Test security group that allows inbound and outbound traffic from anywhere"
  vpc_id = "${aws_vpc.gastown.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  tags { 
    Name = "gastown-private-services" 
    Env = "${var.environment}"
  }
}

resource "aws_instance" "gastown-public-services" {
  count = 1
  ami = "${var.containers_ami}"
  instance_type = "t2.medium"
  subnet_id = "${aws_subnet.us-west-2b-public.id}"
  iam_instance_profile = "ecsInstanceRole"
  associate_public_ip_address = false
  key_name = "${var.aws_key_name}"
  security_groups = [
    "${aws_security_group.gastown-public-services.id}",
  ]
  tags {
    Name = "gastown-public-services"
    Env = "${var.environment}"
  }
}

resource "aws_security_group" "gastown-public-services" {
  name = "gastown-public"
  description = "Test security group that allows inbound and outbound traffic from anywhere"
  vpc_id = "${aws_vpc.gastown.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  tags { 
    Name = "gastown-public-services" 
    Env = "${var.environment}"
  }
}