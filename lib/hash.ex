defmodule MerklePatriciaTree.Hash do
  use Rustler, otp_app: :merkle_patricia_tree, crate: "hash"

  @doc """
    Hashes the given binary using the blake2s hash algorithm.
  """
  @spec blake2(binary) :: binary
  def blake2(val) when is_binary(val) do
    val
    |> _blake2()
    |> :erlang.list_to_binary()
  end
  
  defp _blake2(_) do
    :erlang.nif_error(:nif_not_loaded)
  end
end