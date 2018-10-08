# Description
#   :badger: of integration tests
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

signalfx = require('signalfx')
signalfx_client = new signalfx.Ingest(process.env.SIGNALFX_API_TOKEN)
SIGNALFX_SUCCESSFUL = "successful"
SIGNALFX_FAILED = "failed"

send_signalfx_metric = (metric_name, dimensions) ->
  timestamp = new Date().getTime()
  metric = {
    metric: metric_name,
    value: 1,
    timestamp: timestamp,
    dimensions: dimensions
  }

  signalfx_client.send({ counters:[metric] })

badger_free = (robot, msg) ->
  current_owner = robot.brain.get "badger_owner" || ""

  message_sender = msg.message.user.name.toLowerCase()

  signalfx_metric_name = "badger.free"
  signalfx_metric_dimensions = { message_sender: message_sender }

  if current_owner == ""
    signalfx_metric_dimensions.result = SIGNALFX_FAILED
    msg.send ":badger: is already in the wild"
  else if current_owner == message_sender
    robot.brain.set "badger_owner", ""
    robot.brain.set "badger_time", ""

    signalfx_metric_dimensions.result = SIGNALFX_SUCCESSFUL
    msg.send ":badger: was released into the wild by #{current_owner}"
  else
    signalfx_metric_dimensions.result = SIGNALFX_FAILED
    msg.send ":badger: is currently in the care of #{current_owner}, please wait for them to free the badger"

  send_signalfx_metric(signalfx_metric_name, signalfx_metric_dimensions)

badger_steal = (robot, msg) ->
  current_owner = robot.brain.get "badger_owner" || ""
  badger_time = robot.brain.get "badger_time" || ""

  message_sender = msg.message.user.name.toLowerCase()

  signalfx_metric_name = "badger.steal"
  signalfx_metric_dimensions = { message_sender: message_sender }

  if current_owner == ""
    robot.brain.set "badger_owner", message_sender
    signalfx_metric_dimensions.result = SIGNALFX_SUCCESSFUL
    msg.send ":badger: moved from the wild to the care of #{message_sender}"
  else if current_owner == message_sender
    signalfx_metric_dimensions.result = SIGNALFX_FAILED
    msg.send ":badger: is already in the care of #{current_owner}"
  else
    robot.brain.set "badger_owner", message_sender

    now = new Date()
    date_time = now.toUTCString()
    robot.brain.set "badger_time", date_time

    signalfx_metric_dimensions.result = SIGNALFX_SUCCESSFUL
    msg.send ":badger: was stolen from #{current_owner} by #{message_sender}"

  send_signalfx_metric(signalfx_metric_name, signalfx_metric_dimensions)

badger_take = (robot, msg) ->
  current_owner = robot.brain.get "badger_owner" || ""
  badger_time = robot.brain.get "badger_time" || ""

  message_sender = msg.message.user.name.toLowerCase()

  signalfx_metric_name = "badger.take"
  signalfx_metric_dimensions = { message_sender: message_sender }

  if current_owner == ""
    robot.brain.set "badger_owner", message_sender

    now = new Date()
    date_time = now.toUTCString()
    robot.brain.set "badger_time", date_time

    signalfx_metric_dimensions.result = SIGNALFX_SUCCESSFUL
    msg.send ":badger: moved from the wild to the care of #{message_sender}"
  else if current_owner == message_sender
    signalfx_metric_dimensions.result = SIGNALFX_FAILED
    msg.send ":badger: is already in the care of #{current_owner} since #{badger_time}"
  else
    signalfx_metric_dimensions.result = SIGNALFX_FAILED
    msg.send "#{current_owner} has had :badger: since #{badger_time}, go badger them"

  send_signalfx_metric(signalfx_metric_name, signalfx_metric_dimensions)

badger_where = (robot, msg) ->
  current_owner = robot.brain.get "badger_owner" || ""
  badger_time = robot.brain.get "badger_time" || ""

  message_sender = msg.message.user.name.toLowerCase()

  signalfx_metric_name = "badger.where"
  signalfx_metric_dimensions = { message_sender: message_sender, result: SIGNALFX_SUCCESSFUL }

  if current_owner == ""
    msg.send ":badger: is currently in the wild"
  else
    msg.send ":badger: is currently in the care of #{current_owner} since #{badger_time}"

  send_signalfx_metric(signalfx_metric_name, signalfx_metric_dimensions)

module.exports = (robot) ->
  robot.hear /badger[ ]?take/i, (msg) -> badger_take(robot, msg)

  robot.hear /badger[ ]?free/i, (msg) -> badger_free(robot, msg)

  robot.hear /badger[ ]?where/i, (msg) -> badger_where(robot, msg)

  robot.hear /badger[ ]?steal/i, (msg) -> badger_steal(robot, msg)
