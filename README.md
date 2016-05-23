# Sonar

Elixir interface to AWS.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add sonar to your list of dependencies in `mix.exs`:

        def deps do
          [{:sonar, "~> 0.0.1"}]
        end

  2. Ensure sonar is started before your application:

        def application do
          [applications: [:sonar]]
        end

## Developers, Developers, Developers, Developers

This library is an Elixir interface to the HTTP/RESTish API exposed for AWS (see http://docs.aws.amazon.com/general/latest). It's designed to be easily updated as the API updates, mimicking the method used in boto3.
