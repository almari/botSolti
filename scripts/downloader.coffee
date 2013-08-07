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

  DOWN_LIMIT = robot.brain.get('MAX_DOWN_LiMITS') or 5
  # bot hear to links: {vimeo: [http://vimeo.com/70921986], youtube: [https://www.youtube.com/watch?video=VLeyCX3Em-c]}
  robot.respond /(download) (https?:\/\/www\.youtube\.com\/watch\?.+?|https?:\/\/vimeo\.com\/.+?|.*)(?:\s|$)/i, (msg) ->

    #first check the download limits
    counter = robot.brain.get('present_download_counter') or 0
    console.log "Hey, I am have #{counter} downloads in queue"
    if counter < DOWN_LIMIT
      url_parsed = url.parse(msg.match[2])
      query_parsed = querystring.parse(url_parsed.query)

      video_sites = ['www.youtube.com','vimeo.com']
      console.log(msg.match[2])

      counter += 1
      #inject +1 count to the brain
      robot.brain.set present_download_counter: counter


      if url_parsed.hostname in video_sites
        msg.reply ('hey, wait few minutes ok, cuz... I am downloading video now')

        msg
          .http("http://localhost:4567/video/?video_link=#{msg.match[2]}")
          .get() ( err, res, body )  ->
            counter -= 1
            robot.brain.set present_download_counter: counter
            if res.statusCode is 400
              msg.send "Something went wrong"
            else
              msg.send body
      else
        console.log('Cool, no more videos this time...My task is now easy :D')
        #showInfo msg, video_hash
        #robot.brain.set present_download_counter:counter+1
        msg
          .http("http://localhost:4567/wget/?link=#{msg.match[2]}")
          .get() ( err, res, body )  ->
            counter -= 1
            robot.brain.set present_download_counter: counter
            if res.statusCode is 400
              msg.send "Something went wrong"
            else
              msg.send body
      #counter -= 1
      #robot.brain.set present_download_counter: counter
      #at the end of if reduce the download count

    else
      msg.reply "Sorry, please talk a time to breathe... i also have limits :("
      console.log "the download_count_for now is: #{counter}"

  robot.respond /(set dowload limit|hack my brain) (.*)/i, (msg) ->

    #validating integer input only
    num = msg.match[2] - 0
    if typeof num is 'number' and Math.floor(num)
      robot.brain.set MAX_DOWN_LiMITS: num
      console.log "yo, Thanks for upgrade to  #{num}"
    else
      robot.brain.set MAX_DOWN_LiMITS: 5
      console.log robot.brain.get('MAX_DOWN_LiMITS')
      #    robot.brain.set 'totalBeers', beersHad+1
      # Or robot.brain.set totalBeers: beersHad+1
    msg.reply 'Hey, you hacked me (y)'
