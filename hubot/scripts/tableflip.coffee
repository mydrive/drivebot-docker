# Description
#   Flipping Tables
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   tableflip - Unicode me a tableflip
#
# Notes:
#   None
#
# Author:
#   gavinheavyside
#


module.exports = (robot) ->
  robot.hear /table[ ]?flip/i, (msg) ->
    msg.send "(╯°□°）╯︵ ┻━┻"

  robot.hear /flip(ping)? table/i, (msg) ->
    msg.send "(╯°□°）╯︵ ┻━┻"

  robot.hear /table[ ]restore/i, (msg) ->
    msg.send "┬─┬ノ( º _ ºノ)"

  robot.hear /patience young grasshopper/i, (msg) ->
    msg.send "┬─┬ノ( º _ ºノ)"
