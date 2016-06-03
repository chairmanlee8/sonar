defmodule Sonar.SQS do
    @moduledoc ~S"""
    Stubs for Amazon SQS API.

    """
    @default_aws_region "us-east-1"

    @api_service {"sqs", nil}
    @api_version "2012-11-05"
    @api_methods [
        "AddPermission",
        "ChangeMessageVisibility",
        "ChangeMessageVisibilityBatch",
        "CreateQueue",
        "DeleteMessage",
        "DeleteMessageBatch",
        "DeleteQueue",
        "GetQueueAttributes",
        "GetQueueUrl",
        "ListDeadLetterSourceQueues",
        "ListQueues",
        "PurgeQueue",
        "ReceiveMessage",
        "RemovePermission",
        "SendMessage",
        "SendMessageBatch",
        "SetQueueAttributes"
    ]

    use Sonar.API.Get.XML
end
