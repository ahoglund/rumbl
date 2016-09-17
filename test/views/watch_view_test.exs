defmodule Rumbl.WatchViewTest do
  use Rumbl.ConnCase, async: true
  import Phoenix.View

  test "renders show.html", %{conn: conn} do
    video = %Rumbl.Video{id: "1", title: "dogs", url: "https://www.youtube.com/watch?v=3zDHSLDY0Q8"}
    content = render_to_string(Rumbl.WatchView, "show.html",
                               conn: conn, video: video)

    assert String.contains?(content, video.title)
  end
end
