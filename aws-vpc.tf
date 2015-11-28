provider "aws" {
	access_key = "${var.aws_access_key}"
	secret_key = "${var.aws_secret_key}"
	region = "us-west-2"
}

resource "aws_vpc" "gastown-test" {
	cidr_block = "10.0.0.0/16"
	tags {
	  Name = "gastown-test"
	}
}

resource "aws_internet_gateway" "gastown-test" {
	vpc_id = "${aws_vpc.gastown-test.id}"
	tags {
	  Name = "gastown-test"
	}
}

# NAT instance

resource "aws_security_group" "nat" {
	name = "nat"
	description = "Allow services from the private subnet through NAT"
	tags {
	  Name = "gastown-test-nat"
	}

	ingress {
		from_port = 0
		to_port = 65535
		protocol = "tcp"
		cidr_blocks = ["${aws_subnet.us-west-2b-private.cidr_block}"]
	}
	ingress {
		from_port = 0
		to_port = 65535
		protocol = "tcp"
		cidr_blocks = ["${aws_subnet.us-west-2c-private.cidr_block}"]
	}

	vpc_id = "${aws_vpc.gastown-test.id}"
}

resource "aws_instance" "nat" {
	ami = "${var.aws_nat_ami}"
	availability_zone = "us-west-2b"
	instance_type = "m1.small"
	key_name = "${var.aws_key_name}"
	security_groups = ["${aws_security_group.nat.id}"]
	subnet_id = "${aws_subnet.us-west-2b-public.id}"
	associate_public_ip_address = true
	source_dest_check = false
	tags {
	  Name = "gastown-test-nat"
	  Test = "true"
	  Subnet = "2b-public"
	  Cluster = "gastown-test"
	}
}

resource "aws_eip" "nat" {
	instance = "${aws_instance.nat.id}"
	vpc = true
}

# Public subnets

resource "aws_subnet" "us-west-2b-public" {
	vpc_id = "${aws_vpc.gastown-test.id}"

	cidr_block = "10.0.0.0/24"
	availability_zone = "us-west-2b"
	tags {
	  Name = "gastown-test-2b-public"
	}
}

resource "aws_subnet" "us-west-2c-public" {
	vpc_id = "${aws_vpc.gastown-test.id}"

	cidr_block = "10.0.2.0/24"
	availability_zone = "us-west-2c"
	tags {
	  Name = "gastown-test-2c-public"
	}
}

# Routing table for public subnets

resource "aws_route_table" "us-west-2-public" {
	vpc_id = "${aws_vpc.gastown-test.id}"

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.gastown-test.id}"
	}
	tags {
	  Name = "gastown-test-public"
	}
}

resource "aws_route_table_association" "us-west-2b-public" {
	subnet_id = "${aws_subnet.us-west-2b-public.id}"
	route_table_id = "${aws_route_table.us-west-2-public.id}"
}

resource "aws_route_table_association" "us-west-2c-public" {
	subnet_id = "${aws_subnet.us-west-2c-public.id}"
	route_table_id = "${aws_route_table.us-west-2-public.id}"
}

# Private subsets

resource "aws_subnet" "us-west-2b-private" {
	vpc_id = "${aws_vpc.gastown-test.id}"

	cidr_block = "10.0.1.0/24"
	availability_zone = "us-west-2b"
	tags {
	  Name = "gastown-test-2b-private"
	}
}

resource "aws_subnet" "us-west-2c-private" {
	vpc_id = "${aws_vpc.gastown-test.id}"

	cidr_block = "10.0.3.0/24"
	availability_zone = "us-west-2c"
	tags {
	  Name = "gastown-test-2c-private"
	}	
}

# Routing table for private subnets

resource "aws_route_table" "us-west-2-private" {
	vpc_id = "${aws_vpc.gastown-test.id}"

	route {
		cidr_block = "0.0.0.0/0"
		instance_id = "${aws_instance.nat.id}"
	}
	tags {
	  Name = "gastown-test-private"
	}
}

resource "aws_route_table_association" "us-west-2b-private" {
	subnet_id = "${aws_subnet.us-west-2b-private.id}"
	route_table_id = "${aws_route_table.us-west-2-private.id}"
}

resource "aws_route_table_association" "us-west-2c-private" {
	subnet_id = "${aws_subnet.us-west-2c-private.id}"
	route_table_id = "${aws_route_table.us-west-2-private.id}"
}

# Bastion

resource "aws_security_group" "bastion" {
	name = "bastion"
	description = "Allow SSH traffic from the internet"
	tags {
	  Name = "gastown-test-bastion"
	}

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	vpc_id = "${aws_vpc.gastown-test.id}"
}

resource "aws_instance" "bastion" {
	ami = "${var.aws_ubuntu_ami}"
	availability_zone = "us-west-2b"
	instance_type = "t2.micro"
	key_name = "${var.aws_key_name}"
	security_groups = ["${aws_security_group.bastion.id}"]
	subnet_id = "${aws_subnet.us-west-2b-public.id}"
	tags {
	  Name = "gastown-test-bastion"
	  Test = "true"
	  Subnet = "2b-public"
	  Cluster = "gastown-test"
	}
}

resource "aws_eip" "bastion" {
	instance = "${aws_instance.bastion.id}"
	vpc = true
}