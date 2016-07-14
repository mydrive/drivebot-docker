# Description
#   Khaaaan
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   Khaaaaaan
#
# Notes:
#   None
#
# Author:
#   jfharden
#

khaaan = [
  "https://s3-eu-west-1.amazonaws.com/mydrive-public/images/khaaan1.gif",
  "https://s3-eu-west-1.amazonaws.com/mydrive-public/images/khaaan2.gif",
  "https://s3-eu-west-1.amazonaws.com/mydrive-public/images/khaaan1.jpg",
  "https://s3-eu-west-1.amazonaws.com/mydrive-public/images/khaaan2.jpg"
]

module.exports = (robot) ->
  robot.hear /kha{3,}n/i, (msg) ->
    msg.send msg.random khaaan
