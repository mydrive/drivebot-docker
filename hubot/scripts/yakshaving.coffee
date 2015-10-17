# Description
#   Bovine Shearing
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   yak shaving - Display a source of Yak hair
#
# Notes:
#   None
#
# Author:
#   gavinheavyside
#

yaks = [
  "https://s3-eu-west-1.amazonaws.com/mydrive-public/images/yak.jpg",
  "https://s3-eu-west-1.amazonaws.com/mydrive-public/images/yak2.jpg",
  "https://s3-eu-west-1.amazonaws.com/mydrive-public/images/yak3.jpg"
]

module.exports = (robot) ->
  robot.hear /yak shaving/i, (msg) ->
    msg.send msg.random yaks
