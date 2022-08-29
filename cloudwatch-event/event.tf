# ------------------------------------------------------------------------------
# CloudWatch Event to SNS
# ------------------------------------------------------------------------------
resource "aws_cloudwatch_event_rule" "this" {
  count = module.context.enabled ? 1 : 0

  name                = module.context.id
  name_prefix         = null # don't use
  schedule_expression = var.schedule_expression
  event_pattern       = var.event_pattern
  description         = var.description
  is_enabled          = true
  tags                = module.context.tags

  # TODO
  role_arn       = null
  event_bus_name = null
}

resource "aws_cloudwatch_event_target" "this" {
  count = module.context.enabled ? 1 : 0

  rule = aws_cloudwatch_event_rule.this[0].name
  arn  = var.sns_topic_arn

  dynamic "input_transformer" {
    for_each = toset(var.transformer == null ? [] : [1])

    content {
      input_template = var.transformer.template
      input_paths = var.transformer.paths
    }
  }
}


