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

  robot.respond /k cha$/i, (msg) ->
    msg.send "tik cha ne"

  robot.respond /la nepali bot :p$/i, (msg) ->
    msg.send "म त नेपाली मा pani बोल्न सक्छु, हे हे ☺☺☺"

  robot.respond /aama$/i, (msg) ->
    msg.send "हे कसको रुट password हो यो हँ ? ☺☺☺"

  robot.respond /tait pasa$/i, (msg) ->
    msg.send "j payo tei chai na bola hai pasa"

#  robot.respond /shell$/i, (msg) ->
#    #console.log('entering the command...')
#    msg.http("http://localhost:4567/shell")
#        .get() (err, res, body) ->
#           if res.statusCode == 404
#             msg.send "Something went horribly wrong"
#           else
#             # msg.send "Deployed like a boss"
#             msg.send body

  robot.respond /puri$/i, (msg) ->
    #console.log('entering the command...')
    msg.http("http://localhost:4567/puri")
        .get() (err, res, body) ->
           if res.statusCode == 404
             msg.send "Something went horribly wrong"
           else
             msg.send body
             msg.send res
             msg.send res

#  robot.respond /shell (.*)/i, (msg) ->
#    #console.log('entering the command...')
#    msg.http("http://localhost:4567/puri")
#        .get() (err, res, body) ->
#           if res.statusCode == 404
#             msg.send "Something went horribly wrong"
#           else
#             msg.send body
#             msg.send res
#             msg.send res

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
          #msg.send res
        #return msg.send failureCodes[res.statusCode] if failureCodes[res.statusCode]
        #try
         # msg.send body
          #results = JSON.parse body
          #user = results.user
          #msg.send util.format "%s - %s - %s - %s - %s - %s", user.id, user.first_name, user.last_name, user.username, user.display_name, user.url
          #msg.send util.format "Profile Picture: %s", user.images[115]
