#display funny msg
# Description:
# "Makes your Hubot even more Clever™"
#
# Dependencies:
# "cleverbot-node": "0.1.1"
#
# Configuration:
# None
#
# Commands:
# hubot c <input>
#
# Author:
# ajacksified
# Thanks bro !! --ceasors & gtg

cleverbot = require('cleverbot-node')

module.exports = (robot) ->
  c = new cleverbot()

  robot.respond /(solti) (.*)/i, (msg) ->
    data = msg.match[2].trim()
    c.write(data, (c) => msg.send(c.message))
