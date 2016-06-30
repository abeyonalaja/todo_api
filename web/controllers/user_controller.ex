defmodule TodoApi.UserController do
  use TodoApi.Web, :controller

  alias TodoApi.User
  alias TodoApi.Session

  plug :scrub_params, "user" when action in [:create]

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        session_changeset = Session.create_changeset(%Session{}, %{user_id: user.id})
        {:ok, session} = Repo.insert(session_changeset)
          conn
          |> put_status(:created)
          |> render("new.json", [user: user, session: session])
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TodoApi.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
