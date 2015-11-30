resource "aws_elb" "abbott" {
  name = "abbott-${var.environment}"
  subnets = ["${aws_subnet.us-west-2b-private.id}"]
  security_groups = ["${aws_security_group.gastown-private-services.id}"]
  idle_timeout = 5

  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    target = "HTTP:8080/"
    timeout = 10
    interval = 30
  }
}

resource "aws_db_instance" "abbott" {
  identifier = "abbott-${var.environment}"
  allocated_storage = 5
  engine = "postgres"
  engine_version = "9.4.1"
  instance_class = "db.t1.micro"
  name = "abbott_${var.environment}" 
  username = "abbott"
  password = "paysavvy"
  port = 5432
  db_subnet_group_name = "${aws_db_subnet_group.gastown.id}"
  multi_az = "false"
  final_snapshot_identifier = false
  publicly_accessible = false
  storage_encrypted = false
  vpc_security_group_ids = [ "${aws_security_group.gastown-dbs.id}"]
  apply_immediately = true
  tags { 
    Name = "abbott-db" 
    Env = "${var.environment}"
  }
}
