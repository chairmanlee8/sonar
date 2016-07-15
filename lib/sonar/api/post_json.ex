defmodule Sonar.API.Post.JSON do
    @moduledoc ~S"""
    This module allows you to automatically generate an API for any AWS service through the `using` macro. In your host
    module, simply define the following module attributes:

        @api_version -- API version in YYYYMMDD format
        @api_service -- API service name tuple {short_name, long_name} (e.g. {"ecs", "AmazonEC2ContainerService"} for Amazon ECS)
        @api_methods -- array of API method names to generate

    Then invoke the using macro via `use Sonar.Core.API.Post` and your module will populate with the proper function stubs.

    """

    defmacro __using__(_) do
        quote unquote: false do
            alias Sonar.Core
            alias Sonar.Utils
            alias Sonar.Utils.Amazon

            for method <- @api_methods do
                name = method |> Macro.underscore |> String.to_atom

                def unquote(name)(client, params \\ []) do
                    body = params
                        |> Utils.API.generate_parameter_map
                        |> Poison.encode!

                    {short_api, long_api} = @api_service
                    host = @override_host || "#{short_api}.#{client[:region]}.amazonaws.com"
                    iso_date = Amazon.iso_date

                    %HTTPotion.Response{body: rbody} = Core.Auth.make_request(
                        client[:access_key_id],
                        client[:secret_access_key],
                        client[:region],
                        short_api,
                        "POST", "https://#{host}/",
                        iso_date,
                        body,
                        [
                            {"Host", "#{host}"},
                            {"Accept-Encoding", "identity"},
                            {"Content-Length", String.length(body) |> Integer.to_string},
                            {"X-Amz-Target", "#{long_api}V#{@api_version}.#{unquote(method)}"},
                            {"X-Amz-Date", iso_date},
                            {"Content-Type", "application/x-amz-json-1.1"}
                        ]
                    )

                    rbody |> Poison.Parser.parse!
                end
            end
        end
    end
end
