# Description
#   Ten Pounds
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   Give yourself £10
#
# Notes:
#   None
#
# Author:
#   mhefferan
#

ten_pounds = [
  "https://s3-eu-west-1.amazonaws.com/mydrive-public/images/ten_pounds.jpg"
]

module.exports = (robot) ->
  robot.hear /(£10[^\d]|ten pounds)/i, (msg) ->
    msg.send msg.random ten_pounds
