provider "aws" {
  region  = var.aws_region # Região AWS
  profile = var.aws_profile # Perfil AWS
}

################################################################################
# Criação do Security Group para o ALB
################################################################################
resource "aws_security_group" "sg_alb_instance" {
  name        = "SG-alb-instance" # Nome do Security Group
  description = "Security Group for ALB allowing HTTP and HTTPS"
  vpc_id      = "vpc-id" # ID da VPC

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Abrir HTTP para o mundo
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Abrir HTTPS para o mundo
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Permitir todo o tráfego de saída
  }

  tags = {
    Name = "SG-alb-instance" # Nome do Security Group
  }
}

################################################################################
# Criação do Target Group
################################################################################
resource "aws_lb_target_group" "tg_alb_instance" {
  name        = "tg-alb-instance"  # Nome do Target Group
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "vpc-id" # ID da VPC
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
}

################################################################################
# Adicionando a instância ao Target Group
################################################################################
resource "aws_lb_target_group_attachment" "tg_attachment" {
  target_group_arn = aws_lb_target_group.tg_alb_instance.arn 
  target_id        = "i-98908798798ghyyhgy" # ID da Instância EC2
  port             = 80
}

################################################################################
# Criação do ALB
################################################################################
resource "aws_lb" "alb_teste" {
  name               = "alb-teste" # Nome do ALB
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_alb_instance.id]
  subnets            = [
    "subnet-id", # ID da Subnet 1
    "subnet-id"  # ID da Subnet 2
  ]

  enable_deletion_protection = false

  tags = {
    Name = "alb-teste" # Nome do ALB
  }
}

################################################################################
# Criação do Listener 80 com redirecionamento para 443
################################################################################
resource "aws_lb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.alb_teste.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

################################################################################
# Criação do Listener 443 com SSL e política ELBSecurityPolicy-TLS13-1-2-2021-06
################################################################################
resource "aws_lb_listener" "alb_listener_https" {
  load_balancer_arn = aws_lb.alb_teste.arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06" # Política SSL
  certificate_arn   = "arn:aws:acm:sa-east-1:******:certificate/************" # ARN do Certificado SSL

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_alb_instance.arn
  }
}