defmodule Sonar.ECS do
    @moduledoc ~S"""
    Stubs for Amazon EC2 Container Service API.

    """
    @default_aws_region "us-east-1"

    @api_service        {"ecs", "AmazonEC2ContainerService"}
    @api_version        "20141113"
    @api_methods [
        "ListClusters",
        "ListContainerInstances",
        "ListServices"
    ]

    use Sonar.Core.API
end
