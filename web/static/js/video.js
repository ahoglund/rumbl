import Player from "./player"

let Video = {
  init(socket, element){ if(!element){ return }
    let playerId = element.data("player-id")
    let videoId  = element.data("id")
    socket.connect()
    Player.init(element.attr("id"), playerId, () => {
      this.onReady(videoId, socket)
    })
  },

  onReady(videoId, socket){
    let msgContainer = $("#msg-container")
    let msgInput     = $("#msg-input")
    let postButton   = $("#msg-submit")
    let vidChannel   = socket.channel("videos:" + videoId)
    postButton.click(e => {
      let payload = { body: msgInput.val(), at: Player.getCurrentTime() }
      msgInput.val("")
      vidChannel.push("new_annotation", payload).receive("error", e => console.log("error:", e))
    })
    vidChannel.on("new_annotation", (resp) => { this.renderAnnotation(msgContainer, resp) })

    vidChannel.join()
      .receive("ok",    resp => console.log("joined the video channel", resp))
      .receive("error", reason => console.log("join failed", reason))
  },

  esc(str) {
    let div = document.createElement("div")
    div.appendChild(document.createTextNode(str))
    return div.innerHTML
  },
  renderAnnotation(msgContainer, {user, body, at})  {
    let template = document.createElement("div")

    template.innerHTML = `
      <a href="#" data-seek="${this.esc(at)}">
      <b>${this.esc(user.username)}</b>: ${this.esc(body)}
      </a>`

    msgContainer.append(template)
    msgContainer.scrollTop(msgContainer.height())
  }
}
export default Video
