defmodule TodoApi.Todo do
  use TodoApi.Web, :model

  schema "todos" do
    field :description, :string
    field :complete, :boolean, default: false
    field :owner_id, :integer
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :complete, :owner_id])
    |> validate_required([:description, :complete])
  end
end
