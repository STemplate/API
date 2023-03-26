defmodule Encryption.HashFieldTest do
  use ExUnit.Case
  alias Encryption.Hashing

  test ".hash converts a value to a sha256 hash with secret_key_base as salt" do
    hash = Hashing.hash("some word")

    assert hash == "gqKpoO8J9ZMX1itnTT6fXrZ9dnHgkDZ3yXKLMRE2FMI="
  end
end
