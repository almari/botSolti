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

  robot.respond /kata$/i, (msg) ->
    msg.send "Aa hazur samson ma"
    #console.log(robot)

  robot.respond /(dploy) (.*)/i, (msg) ->
    #get the first command could be one of these {deploy, deploy:setup, deploy:cold}
    deploy_type = msg.match[1]
    str = (msg.match[2]).split(" ")
    #console.log(str)
    #console.log('*********************')
    #str = "-a app -a apple -b main -e cloudy -d dog".split(" ")
    options = ["-a", "-b", "-d", "-e"]
    i = 0
    app = ''
    while i < str.length
      if str[i] is "-a" or str[i] is "-b" or str[i] is "-d" or str[i] is "-e"
        switch str[i]
          when "-a"
            app = str[i + 1]
          when "-e"
            env = str[i + 1]
          when "-b"
            branch = str[i + 1]
          when "-d"
            dest = str[i + 1]
          else
            console.log "cf deploy... invalid_option: " + str[i]
      else
        console.log "Hey, option :" + str[i] + " not avaliable, try again please :)"+"Sorry, your only Available options: " + options
        break
      i += 2
    #end of while

    if app and env and branch and dest
        #if everythings goes right... go left...
        console.log "So you are going to deploy " +  app  + " in " + env + ":environment, branched to:" + branch + " over " + dest

        #now build the link
        params = "app=#{app}&env=#{env}&branch=#{branch}&dest=#{dest}"
        link = "http://localhost:4567/deploy/?#{params}"
        #onsole.log(link)
        msg
          .http(link)
          .get() (err, res, body) ->
                if res.statusCode == 404
                  msg.send "Something went horribly wrong"
                else
                  msg.send body
    #end of if
    else
        console.log "Please check your parameters as in options: " + options
        console.log "Deployment of " + app+ " unsuccessfull :("


  robot.respond /(deploy) (.*)/i, (msg) ->

    str = (msg.match[2]).split(" ")
    if str.length is 4
        #if everythings goes right... go left...
        console.log "Okey buddy, have some coffee now... its my turn to deploy #{str[0]} with #{str[1]} environment branched to:#{str[2]}"
        #now build the link
        params = "app=#{str[0]}&env=#{str[1]}&branch=#{str[2]}&deploy_type=#{str[3]}"
        link = "http://localhost:4567/deploy/?#{params}"
        #console.log(link)
        msg
          .http(link)
          .get() (err, res, body) ->
                if res.statusCode == 404
                  msg.send "Something went horribly wrong"
                else
                  msg.send body
    #end of if
    else
        console.log "Sorry I can take this " + str[0]+ " NO MORE !! :p"
