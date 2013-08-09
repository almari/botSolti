# Description
#   Its a simple intelligent downloader.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot download <download_link>
#
# Notes:
#   For text-based adapters like IRC.
#
# Author:
# cfDevOps team

querystring = require 'querystring'
url = require 'url'

module.exports = (robot) ->

  robot.respond /(search samson|srch) (.*|$)/i, (msg) ->

    console.log(msg.match[2])
    msg
      .http("http://localhost:4567/samson/?search=#{msg.match[2]}")
      .get() ( err, res, body )  ->
        if res.statusCode is 400
          msg.send "Something went wrong"
        else
          msg.send body

  robot.respond /(dump tree|dt)/i, (msg) ->
    msg
      .http("http://localhost:4567/dump/videos/")
      .get() (err, res, body ) ->
        if res.statusCode is 400
          msg.send "Something went wrong"
        else
          msg.send body

  robot.respond /contact (.*)/i, (msg) ->
    console.log msg.match[1]
    msg
      .http("http://localhost:4567/phone/?no=#{msg.match[1]}")
      .get() ( err, res, body ) ->
        if res.statusCode is 400
          msg.send "Something went wrong"
        else
          msg.send body
