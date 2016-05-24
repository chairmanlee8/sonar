defmodule Sonar.ECS do
    @moduledoc ~S"""
    Stubs for Amazon EC2 Container Service API.

    """
    @default_aws_region "us-east-1"

    @api_service {"ecs", "AmazonEC2ContainerService"}
    @api_version "20141113"
    @api_methods [
        "CreateCluster",
        "CreateService",
        "DeleteCluster",
        "DeregisterContainerInstance",
        "DeregisterTaskDefinition",
        "DescribeClusters",
        "DescribeContainerInstances",
        "DescribeServices",
        "DescribeTaskDefinition",
        "DescribeTasks",
        "DiscoverPollEndpoint",
        "ListClusters",
        "ListContainerInstances",
        "ListServices",
        "ListTaskDefinitionFamilies",
        "ListTaskDefinitions",
        "ListTasks",
        "RegisterContainerInstance",
        "RegisterTaskDefinition",
        "RunTask",
        "StartTask",
        "StopTask",
        "SubmitContainerStateChange",
        "SubmitTaskStateChange",
        "UpdateContainerAgent",
        "UpdateService"
    ]

    use Sonar.Core.API
end
