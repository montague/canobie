defmodule Canobie.State do
  use Ecto.Model

  schema "states" do
    field :state, :map
    belongs_to :team, Canobie.Team
    timestamps
  end

  @required_fields ~w(state team_id)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def get_by_user_name(name) do
    from(s in Canobie.State,
      join: t in assoc(s, :team),
      join: u in assoc(t, :users),
      where: u.name == ^name)
    |> Canobie.Repo.all
    |> List.first
  end

  def apply_updates(state, updates) do
    new_state_map = Map.merge(state.state, updates)
    %{state | state: new_state_map}
  end
end

