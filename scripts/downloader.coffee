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

  # bot hear to links: {vimeo: [http://vimeo.com/70921986], youtube: [https://www.youtube.com/watch?video=VLeyCX3Em-c]}
  robot.respond /(download) (https?:\/\/www\.youtube\.com\/watch\?.+?|https?:\/\/vimeo\.com\/.+?|.*)(?:\s|$)/i, (msg) ->

    url_parsed = url.parse(msg.match[2])
    query_parsed = querystring.parse(url_parsed.query)

    video_sites = ['www.youtube.com','vimeo.com']
    console.log(msg.match[2])
    #console.log url_parsed.hostname
    if url_parsed.hostname in video_sites
      msg.reply ('hey, wait few minutes ok, cuz... I am downloading video now')
      msg
        .http("http://localhost:4567/video/?video_link=#{msg.match[2]}")
        .get() ( err, res, body )  ->
            if res.statusCode is 400
              msg.send "Something went wrong"
            else
              msg.send body
    else
      console.log('Cool, no more videos this time...My task is now easy :D')
        #showInfo msg, video_hash
      msg
        .http("http://localhost:4567/wget/?link=#{msg.match[2]}")
        .get() ( err, res, body )  ->
          if res.statusCode is 400
            msg.send "Something went wrong"
          else
            msg.send body
