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

#check if user is a deployer or not ?
isDeployer = (a) ->
  return false  unless a?
  i = 0

  while i < a.length
    return true  if a[i] is "deployee"
    i++
  false

module.exports = (robot) ->
  robot.respond /hi$/i, (msg) ->
    msg.send "hello, Welcome Buddy :D"

  robot.respond /kata$/i, (msg) ->

    whoamI=''
    if process.env.HUBOT_AUTH_ADMIN?
      admins = process.env.HUBOT_AUTH_ADMIN.split ','
      console.log admins
      #check if the user is admin
      whoamI = msg.message.user.name.toString()
      #console.log msg.message.user.id
      #console.log  msg.message.user.roles
      console.log whoamI
      if  whoamI in admins
        msg.send "Aa hazur samson ma"
      else
        msg.send "Sorry fella, ACCESS DENINED !!"

  robot.respond /hey, yo$/i, (msg) ->

    if process.env.HUBOT_AUTH_ADMIN?
      admins = process.env.HUBOT_AUTH_ADMIN.split ','
      console.log admins

      #check if the user is admin
      user = robot.brain.userForId(msg.message.user.id)
      console.log user

      if  user.id in admins
        msg.send "welcome admin"
      else
        msg.send "Booo... so you think you are admin? :P"

  robot.respond /(how to deploy)(\?)?/i, (msg) ->
       msg.reply "Please kindly follow the syntax."
       msg.reply " [cf deploy app_name deployment_environment branch_to_deploy]"
#---------------------------------------------------------------
  robot.respond /(deploy) (.*)/i, (msg) ->

    if process.env.HUBOT_AUTH_ADMIN?
      admins = process.env.HUBOT_AUTH_ADMIN.split ','
      console.log admins

      user = robot.brain.userForId(msg.message.user.id)
      console.log user.roles

      deployers = ['deployee','deployers']
      msg.reply "Ok, you are #{user.roles}... ok deploying..."
      #if user is an admin ... give him deploy access...:)


      if isDeployer(user.roles)  or user.id in admins
        msg.reply "So, you wanna deploy...ok ROGER THAT :D"
        str = (msg.match[2]).split(" ")
        if str.length >= 2

            in_branch = str[2]
            #check if no branch is provided... and use master as a default branch
            in_branch = 'master' if typeof in_branch is "undefined" or not in_branch?

            #if everythings goes right... go left...
            msg.reply "ok bo$$ !! have some coffee now... I need some time to deploy #{str[0]}..."

            #now build the link with parameters
            pars = "app=#{str[0]}&env=#{str[1]}&branch=#{in_branch}"
            link = "http://localhost:4567/deploy/?#{pars}"
            #console.log(link)
            msg
              .http(link)
              .get() (err, res, body) ->
                    if res.statusCode == 404
                      msg.reply "Something went horribly wrong"
                    else
                      msg.reply body
                      #msg.send "Congrats !! deployment just finished..."
        #end of if
        else
            msg.reply "Sorry I can take this....NO MORE !! :p"
            msg.reply "Better try this deploy syntax : [cf deploy app_name deployment_environment branch_to_deploy]"
      else
        msg.reply "Sorry, I am in trouble... Not everybody holds power of deployment."

#---------------------------------------------------------------
