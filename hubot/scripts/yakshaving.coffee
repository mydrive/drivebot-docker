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
  "https://github.com/gavinheavyside/drivebot/raw/master/images/yak.jpg",
  "https://github.com/gavinheavyside/drivebot/raw/master/images/yak2.jpg",
  "https://github.com/gavinheavyside/drivebot/raw/master/images/yak3.jpg"
]

module.exports = (robot) ->
  robot.hear /yak shaving/i, (msg) ->
    msg.send msg.random yaks
