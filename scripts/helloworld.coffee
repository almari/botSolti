# Description:
#   Utility commands surrounding Hubot uptime.
#
#Commands:
#   hubot ping - Reply with pong
#   hubot echo <text> - Reply back with <text>
#   hubot time - Reply with current time
#   hubot die - End hubot process

util = require 'util'
url = require 'url'

module.exports = (robot) ->
  robot.respond /hi$/i, (msg) ->
    msg.send "hello, Welcome Buddy :D"
    #console.log(robot)

#module.exports = (robot) ->
  robot.respond /(bash) (.*)/i, (msg) ->
    link = url.format
      protocol: 'http'
      host: 'localhost:4567'
      pathname: util.format 'bash/%s', msg.match[2]

    msg
      .http(link)
      .get() (err, res, body) ->
        if res.statusCode == 404
          msg.send "Something went horribly wrong"
        else
          msg.send body

  robot.respond /(deploy) (.*)/i, (msg) ->

    #console.log(params.app)
    par = msg.match[2].split(" ")
    #params = { app: par[0]}
    params = "app=#{par[0]}&env=#{par[1]}&branch=#{par[2]}&dest=#{par[3]}"
    link = "http://localhost:4567/deploy/?#{params}"
    console.log(link)
    msg
      .http(link)
      .get() (err, res, body) ->
        if res.statusCode == 404
          msg.send "Something went horribly wrong"
        else
          msg.send body
