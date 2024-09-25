# 1. Define the AWS WAF Web ACL
resource "aws_wafv2_web_acl" "waf" {
  name        = "prod-web-acl"
  scope       = "REGIONAL"  # Use REGIONAL for ALBs, CLOUDFRONT for CloudFront
  description = "prod Web ACL for ALB"
  default_action {
    allow {}
  }


  # Optional: Specify any logging configurations if needed
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "example"
    sampled_requests_enabled   = true
  }

  # 2. Optional: Add AWS WAF Managed Rules or Custom Rules
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "common-rule-set"
      sampled_requests_enabled   = true
    }
  }


# # Attach AWS Managed Rules (Free Rule Sets)
#   rule {
#     name     = "AWS-AWSManagedRulesCommonRuleSet"
#     priority = 2

#     override_action {
#       none {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesCommonRuleSet"  # Free managed rule set
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "common-rule-set"
#       sampled_requests_enabled   = true
#     }
#   }


  # # Example of a custom block rule
  # rule {
  #   name     = "BlockBadBots"
  #   priority = 2

  #   action {
  #     block {}
  #   }

  #   statement {
  #     byte_match_statement {
  #       field_to_match {
  #         single_header {
  #           name = "user-agent"
  #         }
  #       }

  #       text_transformation {
  #         priority = 0
  #         type     = "LOWERCASE"
  #       }

  #       positional_constraint = "CONTAINS"
  #       search_string         = "BadBot"
  #     }
  #   }

  #   visibility_config {
  #     cloudwatch_metrics_enabled = true
  #     metric_name                = "block-bad-bots"
  #     sampled_requests_enabled   = true
  #   }
  # }
 # Step 3: Add AWS Managed Free Rules (AWSManagedRulesAnonymousIpList)
  rule {
    name     = "AWS-AWSManagedRulesAnonymousIpList"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "anonymous-ip-list"
      sampled_requests_enabled   = true
    }
  }

  tags = {
    Name = "example-waf"
  }
}


# 3. Associate the Web ACL with an Application Load Balancer (ALB)
resource "aws_wafv2_web_acl_association" "example" {
  resource_arn = aws_lb.app_alb.arn  # Replace with your ALB ARN
  web_acl_arn  = aws_wafv2_web_acl.waf.arn 
}


