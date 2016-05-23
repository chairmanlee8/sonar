defmodule Sonar.Utils.Amazon do
    @moduledoc ~S"""
    Contains all the little Amazon-unique formatting/manipulation functions.
    """

    @doc ~S"""
    Trimall function as described in the AWS v4 signing process.
    Removes excess white space before and after values, and converts sequential spaces to a single space.

    """
    def trimall(str) do
        str |> String.strip
            |> String.replace(~r/[ ]+/, " ")
    end

    @doc ~S"""
    Return an ISO8601 basic format date for use in x-amz-date.
    """
    def iso_date do
        cal = :calendar.universal_time
        iso_date(cal)
    end

    def iso_date({{y, m, d}, {h, n, s}}) do
        ys = y |> Integer.to_string |> String.rjust(2, ?0)
        ms = m |> Integer.to_string |> String.rjust(2, ?0)
        ds = d |> Integer.to_string |> String.rjust(2, ?0)
        hs = h |> Integer.to_string |> String.rjust(2, ?0)
        ns = n |> Integer.to_string |> String.rjust(2, ?0)
        ss = s |> Integer.to_string |> String.rjust(2, ?0)

        "#{ys}#{ms}#{ds}T#{hs}#{ns}#{ss}Z"
    end
end
