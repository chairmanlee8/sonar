defmodule Sonar do
    @doc ~S"""
    Return an AWS client. Right now we don't have any long poll/advanced API support so it's not a true client, just a
    list of client params to pass to API modules.
    """
    def client(args \\ []) do
        # Use configuration defaults
        a = Application.get_env(:sonar, :aws_access_key_id, args[:aws_access_key_id] || nil)
        s = Application.get_env(:sonar, :aws_secret_access_key, args[:aws_secret_access_key] || nil)
        r = Application.get_env(:sonar, :aws_region, args[:aws_region] || nil)

        [ access_key_id: a,
          secret_access_key: s,
          region: r
        ]
    end
end
