defmodule Encryption.HashFieldTest do
  use ExUnit.Case
  # our Ecto Custom Type for hashed fields
  alias Encryption.HashField, as: Field

  test ".type is :binary" do
    assert Field.type() == :binary
  end

  test ".cast converts a value to a string" do
    assert {:ok, "42"} == Field.cast(42)
    assert {:ok, "atom"} == Field.cast(:atom)
  end

  test ".dump converts a value to a sha256 hash" do
    {:ok, hash} = Field.dump("hello")

    assert hash ==
             "\xE8C\x8A\x8A\xFD\xBD\"O\xFB\x98\x15\xA3\xC4\b\xF2\xE1\xDA\xF9\x16\x81mJ\xD2+\xBAއ\xD9\xD0L\xE7\x82"
  end

  test ".hash converts a value to a sha256 hash with secret_key_base as salt" do
    hash = Field.hash("alex@example.com")

    assert hash ==
             "͗i\xD3^x՜!\\r-\x1E\x03\xD0\xE7|^\x188D\x9CK\xD73(.\xA1U\xFA\xC4\xE6"
  end

  test ".load does not modify the hash, since the hash cannot be reversed" do
    hash =
      <<16, 231, 67, 229, 9, 181, 13, 87, 69, 76, 227, 205, 43, 124, 16, 75, 46, 161, 206, 219,
        141, 203, 199, 88, 112, 1, 204, 189, 109, 248, 22, 254>>

    assert {:ok, ^hash} = Field.load(hash)
  end

  test ".equal? correctly determines hash equality and inequality" do
    hash1 =
      <<16, 231, 67, 229, 9, 181, 13, 87, 69, 76, 227, 205, 43, 124, 16, 75, 46, 161, 206, 219,
        141, 203, 199, 88, 112, 1, 204, 189, 109, 248, 22, 254>>

    hash2 =
      <<10, 231, 67, 229, 9, 181, 13, 87, 69, 76, 227, 205, 43, 124, 16, 75, 46, 161, 206, 219,
        141, 203, 199, 88, 112, 1, 204, 189, 109, 248, 22, 254>>

    assert Field.equal?(hash1, hash1)
    refute Field.equal?(hash1, hash2)
  end

  test "embed_as/1 returns :self" do
    assert Field.embed_as(:self) == :self
  end
end
