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
                name = method |> Macro.underscore |> String.to_atom

                def unquote(name)(client, params \\ []) do
                    {short_api, long_api} = @api_service
                    host = @override_host || "#{short_api}.#{client[:region]}.amazonaws.com"

                    iso_date = Amazon.iso_date
                    premix = [version: @api_version, action: unquote(method)]
                    qs = (premix ++ params) |> Utils.API.generate_parameter_qs

                    %HTTPotion.Response{body: rbody} = Core.Auth.make_request(
                        client[:access_key_id],
                        client[:secret_access_key],
                        client[:region],
                        short_api,
                        "GET", "https://#{host}/?#{qs}", iso_date, "",
                        [
                            {"Host", "#{host}"},
                            {"X-Amz-Date", iso_date},
                            {"Content-Type", "application/x-www-form-urlencoded; charset=utf-8"}
                        ]
                    )

                    # Parse XML
                    {:ok, xmltree, _} = :erlsom.simple_form(rbody, nameFun: fn name, _, _ -> name end)
                    Utils.API.xml_transform(xmltree)
                end
            end
        end
    end
end
