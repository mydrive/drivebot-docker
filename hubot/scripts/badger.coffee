# Description
#   Badger of integration tests
#
#
# Dependencies:
#   hubot-redis-brain
#
# Configuration:
#   None
#
# Commands:
#   badger take - Takes the badger to the user if it's free
#   badger free    - Frees the badger into the wild (integration testing is free)
#   badger where   - Finds out who has the badger
#   badger steal   - Forcefully takes the badger
#
# Notes:
#   The badger can only be taken by one person. The idea being that after integration
#   tests have been ran, the badger is freed for the next person.
#
#   The users can find out who has the badger.
#   Stealing the badger should only be used when the current possessor isn't available
#   such as when they go on holiday and forget to free the badger.
#
#
# Authors:
#   matthewhinks, gavin
#

badger_free = (robot, msg) ->
  current_owner = robot.brain.get "badger_owner" || ""

  message_sender = msg.message.user.name.toLowerCase()

  if current_owner == ""
    msg.send "Badger is already in the wild"
  else if current_owner == message_sender
    robot.brain.set "badger_owner", ""
    robot.brain.set "badger_time", ""

    msg.send "Badger was released into the wild by #{current_owner}"
  else
    msg.send "Badger is currently in the care of #{current_owner}, please wait for them to free the badger"

badger_steal = (robot, msg) ->
  current_owner = robot.brain.get "badger_owner" || ""
  badger_time = robot.brain.get "badger_time" || ""

  message_sender = msg.message.user.name.toLowerCase()

  if current_owner == ""
    robot.brain.set "badger_owner", message_sender
    msg.send "Badger moved from the wild to the care of #{message_sender}"
  else if current_owner == message_sender
    msg.send "Badger is already in the care of #{current_owner}"
  else
    robot.brain.set "badger_owner", message_sender

    now = new Date()
    timestamp = now.toISOString()
    robot.brain.set "badger_time", timestamp

    msg.send "Badger was stolen from #{current_owner} by #{message_sender}"

badger_take = (robot, msg) ->
  current_owner = robot.brain.get "badger_owner" || ""
  badger_time = robot.brain.get "badger_time" || ""

  message_sender = msg.message.user.name.toLowerCase()

  if current_owner == ""
    robot.brain.set "badger_owner", message_sender

    now = new Date()
    timestamp = now.toISOString()
    robot.brain.set "badger_time", timestamp

    msg.send "Badger moved from the wild to the care of #{message_sender}"
  else if current_owner == message_sender
    msg.send "Badger is already in the care of #{current_owner} since #{badger_time}"
  else
    msg.send "#{current_owner} has had Badger since #{badger_time}, go badger them"

badger_where = (robot, msg) ->
  current_owner = robot.brain.get "badger_owner" || ""
  badger_time = robot.brain.get "badger_time" || ""

  if current_owner == ""
    msg.send "Badger is currently in the wild"
  else
    msg.send "Badger is currently in the care of #{current_owner} since #{badger_time}"

module.exports = (robot) ->
  robot.hear /badger[ ]?take/i, (msg) -> badger_take(robot, msg)

  robot.hear /badger[ ]?free/i, (msg) -> badger_free(robot, msg)

  robot.hear /badger[ ]?where/i, (msg) -> badger_where(robot, msg)

  robot.hear /badger[ ]?steal/i, (msg) -> badger_steal(robot, msg)
