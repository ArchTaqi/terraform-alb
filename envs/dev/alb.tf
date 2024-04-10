resource "aws_lb" "alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = module.network.public_subnet_ids

  tags = {
    Environment = "dev"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_a.arn
  }
}
resource "aws_lb_listener_rule" "rule_b" {
  listener_arn = aws_lb_listener.alb_listener.arn
  priority     = 60

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_b.arn
  }

  condition {
    path_pattern {
      values = ["/images*"]
    }
  }
}
resource "aws_lb_listener_rule" "rule_c" {
  listener_arn = aws_lb_listener.alb_listener.arn
  priority     = 40

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_c.arn
  }

  condition {
    path_pattern {
      values = ["/register*"]
    }
  }
}
resource "aws_lb_listener_rule" "rule_lambda" {
  listener_arn = aws_lb_listener.alb_listener.arn
  priority     = 80

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_lambda.arn
  }

  condition {
    path_pattern {
      values = ["/greeting*"]
    }
  }
}

## Target groups
resource "aws_lb_target_group" "alb_tg_a" {
  name     = "target-group-a"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.network.vpc_id
}
resource "aws_lb_target_group" "alb_tg_b" {
  name     = "target-group-b"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.network.vpc_id
}
resource "aws_lb_target_group" "alb_tg_c" {
  name     = "target-group-c"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.network.vpc_id
}
resource "aws_lb_target_group" "alb_tg_lambda" { // Target Group Lambda
  name        = "target-group-lambda"
  target_type = "lambda"
  vpc_id      = module.network.vpc_id
}

// Target group attachment
resource "aws_lb_target_group_attachment" "tg_attachment_a" {
  target_group_arn = aws_lb_target_group.alb_tg_a.arn
  target_id        = module.instance_a.instance_id
  port             = 80
}
resource "aws_lb_target_group_attachment" "tg_attachment_b" {
  target_group_arn = aws_lb_target_group.alb_tg_b.arn
  target_id        = module.instance_b.instance_id
  port             = 80
}
resource "aws_lb_target_group_attachment" "tg_attachment_c" {
  target_group_arn = aws_lb_target_group.alb_tg_c.arn
  target_id        = module.instance_c.instance_id
  port             = 80
}
resource "aws_lb_target_group_attachment" "tg_attachment_lambda" {
  target_group_arn = aws_lb_target_group.alb_tg_lambda.arn
  target_id        = aws_lambda_function.my_lambda.arn
}
