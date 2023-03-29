defmodule Cache.LabelsCache do
  @moduledoc """
  Cache for unique organization labels.
  """
  use GenServer

  alias STemplateAPI.Management.Organization
  alias STemplateAPI.Management

  # Client

  @doc """
  Starts the server.

  ## Examples

    iex> {:ok, pid} = Cache.LabelsCache.start_link()
    {:ok, #PID<0.173.0>}
  """
  @spec start_link(keyword()) :: {:ok, pid}
  def start_link(args \\ []), do: GenServer.start_link(__MODULE__, args, name: __MODULE__)

  @doc """
  Returns the list of unique organization labels.
  """
  def get(organization_id), do: GenServer.call(__MODULE__, {:get, organization_id})

  @doc """
  Updates the list of unique organization labels.
  """
  def update(organization_id), do: GenServer.cast(__MODULE__, {:update, organization_id})

  @doc """
  Updates the list of unique organization labels for all organizations.
  """
  def rebuild(), do: GenServer.cast(__MODULE__, :rebuild)

  # Server

  def init(_args) do
    table = :ets.new(:labels_cache, [:set, :public])

    table |> add_all()

    {:ok, table}
  end

  def handle_call({:get, organization_id}, _from, table) do
    case :ets.lookup(table, organization_id) do
      [{_, labels}] -> {:reply, labels, table}
      [] -> {:reply, [], table}
    end
  end

  def handle_cast({:update, organization_id}, table) do
    :ets.insert(table, {organization_id, organization_id |> labels()})

    {:noreply, table}
  end

  def handle_cast(:rebuild, table) do
    table |> add_all()

    {:noreply, table}
  end

  defp add_all(table) do
    Management.organization_ids()
    |> Enum.each(fn organization_id ->
      :ets.insert(table, {organization_id, organization_id |> labels()})
    end)
  end

  defp labels(organization_id) do
    %Organization{id: organization_id} |> Organization.labels()
  end
end
