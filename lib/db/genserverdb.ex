defmodule MerklePatriciaTree.DB.GenServer do
    @moduledoc """
    Implementation of MerklePatriciaTree.DB which
    is backed by a GenServer.
    """
  
    alias MerklePatriciaTree.Trie
    alias MerklePatriciaTree.DB

    use GenServer
  
    @behaviour MerklePatriciaTree.DB

    # Client

    def start_link(_) do
        GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
    end

    @doc """
    Loads a map in the GenServer DB
    """
    @spec load_db(DB.db_ref(), map) :: :ok
    def load_db(db_ref, db_map) do
        GenServer.call(__MODULE__, {:load, db_ref, db_map})
    end
  
    @doc """
    Retrieves a key from the database.
    """
    @spec get(DB.db_ref(), Trie.key()) :: {:ok, DB.value()} | :not_found
    def get(db_ref, key) do
      GenServer.call(__MODULE__, {:get, db_ref, key})
    end

    @doc """
    Retrieves a map from the GenServer DB
    """
    @spec getdb(DB.db_ref()) :: map
    def getdb(db_ref) do
        GenServer.call(__MODULE__, {:getdb, db_ref})
    end
  
    @doc """
    Stores a key in the database.
    """
    @spec put!(DB.db_ref(), Trie.key(), DB.value()) :: :ok
    def put!(db_ref, key, value) do
      GenServer.call(__MODULE__, {:put, db_ref, key, value})
    end

    @doc """
    Deletes a map from the GenServer DB
    """
    @spec delete_db(DB.db_ref()) :: :ok
    def delete_db(db_ref) do
        GenServer.call(__MODULE__, {:deldb, db_ref})
    end

    # Server

    def init(_) do
        {:ok, %{}}
    end

    def handle_call({:get, dbref, key}, _, state) do
        {:ok, custom_db} = Map.fetch(state, dbref)
        result = case Map.fetch(custom_db, key) do
            {:ok, val} -> {:ok, val}
            :error -> :not_found
        end
        {:reply, result, state}
    end

    def handle_call({:put, db_ref, key , val}, _, state) do
        newdb = case Map.fetch(state, db_ref) do
            {:ok, val} -> val
            _ -> {:error, :not_found}
        end

        updateddb = Map.put(newdb, key, val)
        newstate = Map.put(state, db_ref, updateddb)
        {:reply, :ok, newstate}
    end

    def handle_call({:load, db_ref, db_map}, _, state) do
        {:reply, :ok, Map.put(state, db_ref, db_map)}
    end

    def handle_call({:getdb, db_ref}, _, state) do
        {:ok, thedb} = Map.fetch(state, db_ref)
        {:reply, thedb, state}
    end

    def handle_call({:deldb, db_ref}, _, state) do
        {:reply, :ok, Map.delete(state, db_ref)}
    end
  end
  