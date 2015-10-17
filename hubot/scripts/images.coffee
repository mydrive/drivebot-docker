# Description
#   Images
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   chuck norris me - display Chuck approval
#   borat me - display Borat thumbs up
#   /ff+uu+/ - show rage face
#
# Notes:
#   None
#
# Author:
#   gavinheavyside
#

module.exports = (robot) ->
  robot.respond /chuck norris me/i, (msg) ->
    msg.send "https://s3-eu-west-1.amazonaws.com/mydrive-public/images/chucknorris.jpg"

  robot.respond /borat me/i, (msg) ->
    msg.send "https://s3-eu-west-1.amazonaws.com/mydrive-public/images/borat.jpg"

  robot.hear /ff+uu+/i, (msg) ->
    msg.send "https://s3-eu-west-1.amazonaws.com/mydrive-public/images/rageface.png"

