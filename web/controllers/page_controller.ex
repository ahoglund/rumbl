defmodule Rumbl.PageController do
  use Rumbl.Web, :controller
  alias Rumbl.Video

  def index(conn, _params) do
    videos = Repo.all(Video)
    render(conn, "index.html", videos: videos)
  end
end
