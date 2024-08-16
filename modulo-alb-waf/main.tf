provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
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
  target_id        = "i-88887666gggg" # ID da Instância EC2
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
  certificate_arn   = "arn:aws:acm:sa-east-1:**********:certificate/**********" # ARN do Certificado SSL já validado DNS

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_alb_instance.arn
  }
}

################################################################################
# Criação do WAF WebACL e Regras
################################################################################
resource "aws_wafv2_web_acl" "waf_acl" {
  name        = "test-waf"  # Nome do WAF WebACL
  scope       = "REGIONAL"  # "REGIONAL" para ALBs
  description = "WAF Test"  # Descrição do WAF WebACL

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesBotControlRuleSet"
    priority = 0
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesBotControlRuleSet"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesBotControlRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesAdminProtectionRuleSet"
    priority = 1
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesAdminProtectionRuleSet"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAdminProtectionRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 2
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesAmazonIpReputationList"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesAnonymousIpList"
    priority = 3
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesAnonymousIpList"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAnonymousIpList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 4
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 5
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesLinuxRuleSet"
    priority = 6
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesLinuxRuleSet"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesLinuxRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesUnixRuleSet"
    priority = 7
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesUnixRuleSet"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesUnixRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 8
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesSQLiRuleSet"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "webACL"
    sampled_requests_enabled   = true
  }
}

################################################################################
# Associação do WAF WebACL com o ALB criado!
################################################################################
resource "aws_wafv2_web_acl_association" "waf_acl_assoc" {
  resource_arn = aws_lb.alb_teste.arn # ARN do ALB
  web_acl_arn  = aws_wafv2_web_acl.waf_acl.arn
}
