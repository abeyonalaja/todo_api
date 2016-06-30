defmodule TodoApi.UserControllerTest do
  use TodoApi.ConnCase

  alias TodoApi.User
  alias TodoApi.Session

  @valid_attrs %{email: "foo@bar.com", password: "s3cr3t"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accepts", "application/json")} 
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    body = json_response(conn, 201)
    token = json_response(conn, 201)["token"]
    assert body["id"]
    assert body["email"]
    assert Repo.get_by(Session, token: token)
    refute body["data"]["password"]
    assert Repo.get_by(User, email: "foo@bar.com")
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end


  
end
