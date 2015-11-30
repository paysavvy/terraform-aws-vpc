#Staging Gateway load balancer

resource "aws_elb" "gateway" {
  name = "gateway-${var.environment}"
  subnets = ["${aws_subnet.us-west-2b-public.id}"]
  security_groups = ["${aws_security_group.gastown-public-services.id}"]
  idle_timeout = 5

  listener {
    instance_port = 8888
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    target = "HTTP:8888/"
    timeout = 10
    interval = 30
  }
}