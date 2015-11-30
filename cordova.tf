resource "aws_elb" "cordova" {
  name = "cordova-${var.environment}"
  subnets = ["${aws_subnet.us-west-2b-private.id}"]
  security_groups = ["${aws_security_group.gastown-private-services.id}"]
  idle_timeout = 5
  internal = true
  
  listener {
    instance_port = 8081
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    target = "HTTP:8081/"
    timeout = 10
    interval = 30
  }
}

resource "aws_db_instance" "cordova" {
    identifier = "cordova-${var.environment}"
    allocated_storage = 5
    engine = "postgres"
    engine_version = "9.4.1"
    instance_class = "db.t1.micro"
    name = "cordova_${var.environment}" 
    username = "cordova"
    password = "paysavvy"
    multi_az = "false"
    port = 5432
    db_subnet_group_name = "${aws_db_subnet_group.gastown.id}"
    vpc_security_group_ids = ["${aws_security_group.gastown-dbs.id}"]
    final_snapshot_identifier = false
    publicly_accessible = false
    storage_encrypted = false
    apply_immediately = true
    tags { 
      Name = "cordova-db" 
      Env = "${var.environment}"
    }
}