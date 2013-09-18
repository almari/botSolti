# Description:
#   Utility commands surrounding Hubot uptime.
#
#Commands:
#   hubot create user FirstName LastName
#   hubot delete|destroy user userko@emailid.com
#   hubot get user userko@emailid.com
#   hubot list user all
#


util = require 'util'
url = require 'url'
BASEURL='http://localhost:4567'

#function for http request to the sinatra app
botRequest = (message, path, action, options, callback) ->
  # console.log path
  # console.log action
  # console.log options
  # console.log callback

  message
    .http("#{BASEURL}/#{path}")
    .query(options)[action]() (err, res, body) ->
       callback(err,res,body)

#check if user is googleApps Admin or Not
isGoogleSuperAdmin = (a) ->
  return false  unless a?
  i = 0

  while i < a.length
    return true  if a[i] is "googleAdmin"
    i++
  false

module.exports = (robot) ->
  robot.respond /(.*) user (.*)$/i, (msg) ->

    if process.env.HUBOT_AUTH_ADMIN?
      admins = process.env.HUBOT_AUTH_ADMIN.split ','
#      console.log admins

      user = robot.brain.userForId(msg.message.user.id)
#      console.log user.roles


    #if user is an googleAdmin or simply admin grant him access
    #if isGoogleSuperAdmin(user.roles)  or user.id in admins
    if msg.match[1] and msg.match[2]

      # console.log msg.match[1]
      # console.log msg.match[2]
      msg.reply "Master, (bow) I am ready to create a new user"
      action = (msg.match[1]).split(" ")
      str = (msg.match[2]).split(" ")
#      console.log str

      switch action[0]
        when "create"
          console.log "creating user #{str[0]} #{str[1]}"
          botRequest msg, "createUser", 'post', { name: str[0], sname: str[1]}, (err,res,body) ->
            msg.reply body

        when "delete" , "destroy","remove"
          console.log "deleting user: #{str[0]} ?"
          botRequest msg, "deleteUser", 'delete', { email: str[0]}, (err,res,body) ->
             msg.reply body

        when "get"
          console.log "getting user"#getUser
          botRequest msg, "getUser", 'get', { email: str[0]}, (err,res,body) ->
             msg.reply body


        when "list" "getall"
          console.log "listing user#{str[0]}"
          botRequest msg, "listUsers", 'get', { domain: "sukulgunda.mygbiz.com"}, (err,res,body) ->
             msg.reply body

        when "update" then console.log "updating user... Sorry this feature is not availabel yet."#updateUser


        else msg.reply "Execuse Me :  I don't know what you are talking about."

#-------------------------------------------------------------------------------------------
