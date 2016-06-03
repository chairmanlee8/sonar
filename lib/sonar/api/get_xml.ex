defmodule Sonar.API.Get.XML do
    @moduledoc ~S"""
    This module allows you to automatically generate an API for any AWS service through the `using` macro. In your host
    module, simply define the following module attributes:

        @api_version -- API version in YYYYMMDD format
        @api_service -- API service name tuple {short_name, long_name} (e.g. {"ecs", "AmazonEC2ContainerService"} for Amazon ECS)
        @api_methods -- array of API method names to generate

    Then invoke the using macro via `use Sonar.Core.API.Get` and your module will populate with the proper function stubs.

    """

    defmacro __using__(_) do
        quote unquote: false do
            alias Sonar.Core
            alias Sonar.Utils
            alias Sonar.Utils.Amazon

            for method <- @api_methods do
                name = method |> Mix.Utils.underscore |> String.to_atom

                def unquote(name)(auth, params \\ []) do
                    {short_api, long_api} = @api_service
                    premix = [version: @api_version, action: unquote(method)]

                    qs = (premix ++ params) |> Utils.API.generate_parameter_qs

                    %HTTPotion.Response{body: rbody} = Core.Auth.make_request(
                        auth[:aws_access_key],
                        auth[:aws_secret_key],
                        auth[:aws_region] || @default_aws_region,
                        short_api,
                        "GET", "https://#{short_api}.#{@default_aws_region}.amazonaws.com/?#{qs}", "",
                        [
                            {"Host", "#{short_api}.#{@default_aws_region}.amazonaws.com"},
                            {"X-Amz-Date", Amazon.iso_date},
                            {"Content-Type", "application/x-www-form-urlencoded; charset=utf-8"}
                        ]
                    )

                    # TODO: parse XML
                    rbody
                end
            end
        end
    end
end
