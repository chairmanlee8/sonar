defmodule Sonar.Core.Auth do
    @moduledoc ~S"""
    This module contains everything needed to complete the signing process for an AWS API request.

    Eventually, we may move to use an auth/ subdirectory if we support additional signing processes, but right now since
    we are only using AWS Signature v4 this singular file should be sufficient.

    """
    alias Sonar.Utils
    alias Sonar.Utils.Amazon

    def make_request(aws_access_key, aws_secret_key, region, service, method, url, body \\ "", headers \\ []) do
        # Step 1: http://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
        # Generate canonical request string

        %URI{path: path, query: query} = URI.parse(url)
        qs = (query || "") |> URI.query_decoder |> Enum.map(&(&1)) |> Enum.sort_by(&(&1))

        # TODO: does not handle multiple header consolidation!!
        chs = headers
            |> Enum.map(fn {name, value} -> {String.downcase(name), Amazon.trimall(value)} end)
            |> Enum.sort_by(&(&1))
            |> Enum.map(fn {name, value} -> "#{name}:#{value}" end)

        shs = headers
            |> Enum.map(fn {a, _} -> a end)
            |> Enum.map(&String.downcase/1)
            |> Enum.sort
            |> Enum.join(";")

        hash = :crypto.hash(:sha256, body)
            |> Base.encode16(case: :lower)

        canonical = Enum.join([
            "#{method}\n",
            "#{URI.encode(path)}\n",
            "#{qs |> Enum.map(fn {k, v} -> URI.encode("#{k}=#{v}") end) |> Enum.join("&")}\n",
            "#{Enum.join(chs, "\n")}\n\n",
            "#{shs}\n",
            "#{hash}"
        ])

        canonical_hash = :crypto.hash(:sha256, canonical)
            |> Base.encode16(case: :lower)

        # Step 2
        # Create string to sign

        iso_date = Amazon.iso_date
        iso_date_head = iso_date |> String.split("T") |> Enum.at(0)

        credential_scope = "#{iso_date_head}/#{region}/#{service}/aws4_request"

        signing_string = Enum.join([
            "AWS4-HMAC-SHA256\n",
            "#{Amazon.iso_date}\n",
            "#{credential_scope}\n",
            "#{canonical_hash}"
        ])

        # Step 3
        # Calculate the AWS v4 signature

        k_secret  = aws_secret_key
        k_date    = :crypto.hmac(:sha256, "AWS4#{k_secret}", iso_date_head)
        k_region  = :crypto.hmac(:sha256, k_date, region)
        k_service = :crypto.hmac(:sha256, k_region, service)
        k_signing = :crypto.hmac(:sha256, k_service, "aws4_request")

        signature = :crypto.hmac(:sha256, k_signing, signing_string)
            |> Base.encode16(case: :lower)

        # Step 4+
        # Make the request

        authorize = {
            "Authorization",
            "AWS4-HMAC-SHA256 Credential=#{aws_access_key}/#{credential_scope}, SignedHeaders=#{shs}, Signature=#{signature}"
        }

        # Convert to HTTPotion headers format
        final_headers = [authorize | headers]
            |> Enum.into([])

        HTTPotion.request(atomize_method(method), url, [body: body, headers: final_headers])
    end

    defp atomize_method(method) do
        case String.upcase(method) do
            "GET"    -> :get
            "POST"   -> :post
            "DELETE" -> :delete
            "PUT"    -> :put
            _        -> :unknown
        end
    end
end
