resource "aws_sns_topic" "this" {
  count = module.context.enabled ? 1 : 0

  name              = module.context.id
  name_prefix       = null # don't use
  display_name      = module.context.id
  tags              = module.context.tags
  kms_master_key_id = var.kms_master_key_id

  # TODO
  fifo_topic                               = null
  content_based_deduplication              = null
  policy                                   = null
  delivery_policy                          = null
  application_success_feedback_role_arn    = null
  application_success_feedback_sample_rate = null
  application_failure_feedback_role_arn    = null
  http_success_feedback_role_arn           = null
  http_success_feedback_sample_rate        = null
  http_failure_feedback_role_arn           = null
  lambda_success_feedback_role_arn         = null
  lambda_success_feedback_sample_rate      = null
  lambda_failure_feedback_role_arn         = null
  sqs_success_feedback_role_arn            = null
  sqs_success_feedback_sample_rate         = null
  sqs_failure_feedback_role_arn            = null
  firehose_success_feedback_role_arn       = null
  firehose_success_feedback_sample_rate    = null
  firehose_failure_feedback_role_arn       = null
}

resource "aws_sns_topic_policy" "this" {
  count = module.context.enabled ? 1 : 0

  arn    = one(aws_sns_topic.this[*].arn)
  policy = one(data.aws_iam_policy_document.this[*].json)
}

data "aws_iam_policy_document" "this" {
  count = module.context.enabled ? 1 : 0

  policy_id = module.context.id

  statement {
    sid       = "AllowPub"
    effect    = "Allow"
    actions   = ["SNS:Publish"]
    resources = [one(aws_sns_topic.this[*].arn)]

    principals {
      type = "Service"
      identifiers = [
        "cloudwatch.amazonaws.com",
        "events.amazonaws.com"
      ]
    }

    dynamic "principals" {
      for_each = var.pub_principals
      content {
        type        = principals.key
        identifiers = principals.value
      }
    }
  }

  dynamic "statement" {
    for_each = var.sub_principals
    content {
      sid       = "AllowSub"
      effect    = "Allow"
      actions   = ["SNS:Subscribe"]
      resources = [one(aws_sns_topic.this[*].arn)]

      principals {
        type        = statement.key
        identifiers = statement.value
      }
    }
  }
}
