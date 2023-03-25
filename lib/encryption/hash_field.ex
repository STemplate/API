defmodule Encryption.HashField do
  @moduledoc """
  The HashField custom Ecto Type. Allow to store hashed data.
  """

  @behaviour Ecto.Type

  # . e.g: :integer or :binary
  # cast/1 -  e.g: Integer to String.
  # dump/1 -
  # load/1 - .
  # embed_as/1 -  (not used here).
  # equal?/2 -

  @doc """
  Define the Ecto Type we want Ecto to use to store the data for our Custom Type
  """
  def type, do: :binary

  @doc """
  "typecasts" (converts) the given data to the desired type
  """
  def cast(value) do
    {:ok, to_string(value)}
  end

  @doc """
  Performs the "processing" on the raw data before it get's "dumped" into the Ecto Native Type.
  """
  def dump(value) do
    {:ok, hash(value)}
  end

  @doc """
  Called when loading data from the database and receive an Ecto native type
  """
  def load(value) do
    {:ok, value}
  end

  @doc """
  The return value (:self or :dump) determines how the type is treated inside embeds
  Not used here.
  """
  def embed_as(_), do: :self

  @doc """
  Invoked to determine if changing a type's field value changes the corresponding database value.
  """
  def equal?(value1, value2), do: value1 == value2

  @doc """
  Hash the given value using SHA256
  """
  def hash(value) do
    :crypto.hash(:sha256, value <> get_salt(value))
  end

  # Get/use Phoenix secret_key_base as "salt" for one-way hashing Email address
  # use the *value* to create a *unique* "salt" for each value that is hashed:
  defp get_salt(value) do
    secret_key_base =
      Application.get_env(:s_template_api, STemplateAPIWeb.Endpoint)[:secret_key_base]

    :crypto.hash(:sha256, value <> secret_key_base)
  end
end
