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


  robot.respond /(how to deploy)(\?)?/i, (msg) ->
       console.log "Please kindly follow the syntax."
       console.log " [cf deploy app_name deployment_environment branch_to_deploy]"


  robot.respond /(deploy) (.*)/i, (msg) ->

    str = (msg.match[2]).split(" ")
    if str.length >= 2

        in_branch = str[2]
        #check if no branch is provided... and use master as a default branch
        in_branch = 'master' if typeof in_branch is "undefined" or not in_branch?

        #if everythings goes right... go left...
        console.log "ok bo$$ !! have some coffee now... I need some time to deploy #{str[0]}... from #{in_branch} branch "
        #now build the link with parameters
        pars = "app=#{str[0]}&env=#{str[1]}&branch=#{in_branch}"
        link = "http://localhost:4567/deploy/?#{pars}"
        #console.log(link)
        msg
          .http(link)
          .get() (err, res, body) ->
                if res.statusCode == 404
                  msg.send "Something went horribly wrong"
                else
                  msg.send body
                  #msg.send "Congrats !! deployment just finished..."
    #end of if
    else
        console.log "Sorry I can take this....NO MORE !! :p"
        console.log "Better try this deploy syntax : [cf deploy app_name deployment_environment branch_to_deploy]"
