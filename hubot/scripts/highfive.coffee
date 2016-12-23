# Description
#   High Five
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   highfive
#
# Notes:
#   None
#
# Author:
#   jfharden
#

highfive = [
  "https://s3-eu-west-1.amazonaws.com/mydrive-public/images/highfive/highfive1.gif",
  "https://s3-eu-west-1.amazonaws.com/mydrive-public/images/highfive/highfive2.png",
  "https://s3-eu-west-1.amazonaws.com/mydrive-public/images/highfive/highfive3.png",
  "https://s3-eu-west-1.amazonaws.com/mydrive-public/images/highfive/highfive4.jpg"
  "https://s3-eu-west-1.amazonaws.com/mydrive-public/images/highfive/highfive5.png",
  "https://s3-eu-west-1.amazonaws.com/mydrive-public/images/highfive/highfive6.png",
  "https://s3-eu-west-1.amazonaws.com/mydrive-public/images/highfive/highfive7.jpg",
  "https://s3-eu-west-1.amazonaws.com/mydrive-public/images/highfive/highfive8.jpg"
]

module.exports = (robot) ->
  robot.hear /highfive/i, (msg) ->
    msg.send msg.random highfive
