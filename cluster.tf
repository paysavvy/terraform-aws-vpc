#Amazon ECS-Optimized Amazon Linux AMI
resource "aws_instance" "gastown-test-instance" {
  count = 1
  ami = "${var.containers_ami}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.us-west-2b-private.id}"
  iam_instance_profile = "ecsInstanceRole"
  associate_public_ip_address = false
  key_name = "${var.aws_key_name}"
  security_groups = [
    "${aws_security_group.gastown-test.id}",
  ]
  tags {
    Name = "gastown-test-instance"
    Test = "true"
    Subnet = "2b-private"
    Cluster = "gastown-test"
  }
}

resource "aws_security_group" "gastown-test" {
  name = "test"
  description = "Test security group that allows inbound and outbound traffic from anywhere"
  vpc_id = "${aws_vpc.gastown-test.id}"

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
    Name = "gastown-test-instance" 
  }
}
