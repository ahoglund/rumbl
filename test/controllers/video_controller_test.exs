defmodule Rumbl.VideoControllerTest do
  use Rumbl.ConnCase
  alias Rumbl.Video
  alias Rumbl.Repo

  @valid_attrs %{url: "http://youtu.be.com", title: "a video", description: "video"}
  @invalid_attrs %{title: "Invalid"}

  setup %{conn: conn } = config do
    if username = config[:login_as] do
      user = insert_user(username: username)
      conn = assign(conn(), :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  test "auth on all actions", %{conn: conn} do
    Enum.each([
        get(conn, video_path(conn, :new)),
        get(conn, video_path(conn, :index)),
        get(conn, video_path(conn, :show, "123")),
        get(conn, video_path(conn, :edit, "123")),
        put(conn, video_path(conn, :update, "123", %{})),
        post(conn, video_path(conn, :create, %{})),
        delete(conn, video_path(conn, :delete, "123")),
      ], fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end
    )
  end

  @tag login_as: "bob"
  test "list all videos on users index", %{conn: conn, user: user} do
    user_video = insert_video(user, title: "new video")
    other_video = insert_video(insert_user(name: "larry"), title: "larry's vid")

    conn = get conn, video_path(conn, :index)
    assert html_response(conn, 200)
    assert String.contains?(conn.resp_body, user_video.title)
    refute String.contains?(conn.resp_body, other_video.title)
  end

  @tag login_as: "bob"
  test "creates user video and redirects", %{conn: conn, user: user} do
    conn = post conn, video_path(conn, :create), video: @valid_attrs
    assert redirected_to(conn) == video_path(conn, :index)
    assert Repo.get_by!(Video, @valid_attrs).user_id == user.id
  end

  @tag login_as: "bob"
  test "returns error when video params invalid",  %{conn: conn, user: _user} do
    count_before = video_count(Video)
    conn = post conn, video_path(conn, :create), video: @invalid_attrs
    assert html_response(conn, 200) =~ "error"
    assert video_count(Video) == count_before
  end

  @tag login_as: "bob"
  test "authorizes actions against access by other users", %{user: owner, conn: conn} do
    video = insert_video(owner, @valid_attrs)
    non_owner = insert_user(username: "script kiddy")
    conn = assign(conn, :current_user, non_owner)
    assert_error_sent :not_found, fn ->
      get(conn, video_path(conn, :show, video))
    end
    assert_error_sent :not_found, fn ->
      get(conn, video_path(conn, :edit, video))
    end
    assert_error_sent :not_found, fn ->
      get(conn, video_path(conn, :update, video))
    end
    assert_error_sent :not_found, fn ->
      get(conn, video_path(conn, :delete, video))
    end
  end
  defp video_count(query), do: Repo.one(from v in query, select: count(v.id))
end
