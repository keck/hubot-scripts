# Description:
#   donutme
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot donut me - Receive a donut
#   hubot donut bomb N - get N donuts
#
# Author:
#   donutme@perlhack.com

module.exports = (robot) ->

  robot.respond /donut me/i, (msg) ->
    msg.http("http://perlhack.com/donutme/?random")
      .get() (err, res, body) ->
        msg.send JSON.parse(body).donut

  robot.respond /donut bomb( (\d+))?/i, (msg) ->
    count = msg.match[2] || 5
    msg.http("http://perlhack.com/donutme/?count=" + count)
      .get() (err, res, body) ->
        msg.send donut for donut in JSON.parse(body).donuts
