defmodule Sonar.ECS do
    @moduledoc ~S"""
    Stubs for Amazon EC2 Container Service API.

    """
    @api_service        "ecs"
    @api_version        "2014-11-13"

    @default_aws_region "us-east-1"

    alias Sonar.Core
    alias Sonar.Utils
    alias Sonar.Utils.Amazon

    def list_clusters(auth, params) do
        body = params
            |> Utils.API.generate_parameter_map
            |> Poison.encode!

        Core.Auth.make_request(
            auth[:aws_access_key],
            auth[:aws_secret_key],
            auth[:aws_region] || @default_aws_region,
            @api_service,
            "POST", "https://#{@api_service}.#{@default_aws_region}.amazonaws.com/",
            body,
            [
                {"Host", "#{@api_service}.#{@default_aws_region}.amazonaws.com"},
                {"Accept-Encoding", "identity"},
                {"Content-Length", String.length(body) |> Integer.to_string},
                {"X-Amz-Target", "AmazonEC2ContainerServiceV20141113.ListClusters"},
                {"X-Amz-Date", Amazon.iso_date},
                {"Content-Type", "application/x-amz-json-1.1"}
            ]
        )
    end
end
