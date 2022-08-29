variable "description" {
  type    = string
  default = ""
}

variable "sns_topic_arn" {
  type    = string
  default = ""
}

variable "event_pattern" {
  type        = string
  default     = ""
  description = "Either `event_pattern` or `schedule_expression` must be defined"
}

variable "schedule_expression" {
  type        = string
  default     = ""
  description = "Either `event_pattern` or `schedule_expression` must be defined"
}

variable "transformer" {
  type = object({
    template = string
    paths = map(string)
  })
  default = null
}
