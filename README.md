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

This library is an Elixir interface to the HTTP/RESTish API exposed for AWS (see http://docs.aws.amazon.com/general/latest). It's designed to be easily updated as the API updates, mimicking the method used in boto3. APIs are generated with a `using` macro in `Sonar.Core.API`, following a generic specification which can also be loaded from file in the future, thanks to Elixir's competent metaprogramming facilities.

## Bucket List

Right now the abstractions are not finalized, need to hit some more AWS services to know what makes sense. Example questions: are POST-type APIs always JSON bodies? GET-type APIs always XML returns? Etc.
