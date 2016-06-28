defmodule Sonar.Utils.API do
    @moduledoc ~S"""
    API generation utilities.
    """

    def generate_parameter_map(params) do
        params |> Enum.map(
            fn {key, value} ->
                [jkey_h | jkey_t] = key
                    |> Atom.to_string
                    |> String.split("_")

                jkey = [jkey_h | Enum.map(jkey_t, &String.capitalize/1)]
                    |> Enum.join

                {jkey, value}
            end
        ) |> Enum.into(%{})
    end

    @doc ~S"""
    Fucking wow...
    """
    def generate_parameter_map2(params) do
        params |> Enum.map(
            fn {key, value} ->
                jkey = key
                    |> Atom.to_string
                    |> String.split("_")
                    |> Enum.map(&String.capitalize/1)
                    |> Enum.join

                {jkey, value}
            end
        ) |> Enum.into(%{})
    end

    def generate_parameter_qs(params) do
        params
            |> Enum.map(fn {k, v} -> "#{k |> Atom.to_string |> Mix.Utils.camelize |> URI.encode}=#{v |> URI.encode |> String.replace("+", "%2B")}" end)
            |> Enum.join("&")
    end

    def xml_transform({tag, _, [c | cs]}) do
        if length(cs) == 0 do
            {Mix.Utils.underscore(to_string(tag)), xml_transform(c)}
        else
            {Mix.Utils.underscore(to_string(tag)), [c | cs] |> Enum.map(&xml_transform/1)}
        end
    end
    def xml_transform(c), do: c
end
