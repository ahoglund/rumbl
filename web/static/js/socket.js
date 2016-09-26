import {Socket} from "phoenix"
let socket = new Socket("/socket", {
  params: { token: window.userToken },
  logger: (kind, msg, data) => { console.log("socket log:", msg) }
})
export default socket
