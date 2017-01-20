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

table_flipper = (robot, msg) ->
  if (robot.brain.get "table_flip_state") == "flipped"
    msg.send "(╯°□°）╯︵ ┬─┬"
    robot.brain.set "table_flip_state", "upright"
  else
    msg.send "(╯°□°）╯︵ ┻━┻"
  robot.brain.set "table_flip_state", "flipped"

table_restorer = (robot, msg) ->
  if (robot.brain.get "table_flip_state") == "flipped"
    msg.send "┬─┬ノ( º _ ºノ)"
    robot.brain.set "table_flip_state", "upright"
  else
    msg.send "┬─┬ ヽ( ° _ °)ノ"

module.exports = (robot) ->
  robot.hear /table[ ]?flip/i, (msg) -> table_flipper(robot,msg)

  robot.hear /flip(ping)? table/i, (msg) -> table_flipper(robot,msg)

  robot.hear /table[ ]restore/i, (msg) -> table_restorer(robot, msg)

  robot.hear /patience young grasshopper/i, (msg) -> table_restorer(robot, msg)
