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
#   badger take  - Takes the badger to the user if it's free
#   badger free  - Frees the badger into the wild (integration testing is free)
#   badger where - Finds out who has the badger
#   badger steal - Forcefully takes the badger
#
# Notes:
#   The badger can only be taken by one person. The idea being that after integration
#   tests have been ran, the badger is freed for the next person.
#
#   The users can find out who has the badger.
#   Stealing the badger should only be used when the current possessor isn't available
#   such as when they go on holiday and forget to free the badger.
#


class Badger
  constructor: (@robot) ->
    @signalfx = new SignalFX
    @date_time = -> new Date().toUTCString()
    @badger_owner = -> @robot.brain.get "badger_owner" || ""
    @badger_time = -> @robot.brain.get "badger_time" || ""
    @badger_is_free = -> @badger_owner() == ""
    @badger_owner_is_sender = (msg) -> @badger_owner() == message_sender(msg)
    @save_badger_info = (badger_owner, badger_time) ->
      @robot.brain.set "badger_owner", badger_owner
      @robot.brain.set "badger_time", badger_time


  free: (msg) ->
    if @badger_is_free()
      signalfx_metric_attempt_result = @signalfx.FAILED
      msg.send ":badger: is already in the wild"
    else if @badger_owner_is_sender(msg)
      @save_badger_info("", "")
      signalfx_metric_attempt_result = @signalfx.SUCCESSFUL
      msg.send ":badger: was released into the wild by #{message_sender(msg)}"
    else
      signalfx_metric_attempt_result = @signalfx.FAILED
      msg.send ":badger: is currently in the care of #{@badger_owner()}, please wait for them to free the badger"

    @signalfx.send_metric("free", message_sender(msg), signalfx_metric_attempt_result)

  steal: (msg) ->
    if @badger_is_free()
      @save_badger_info(message_sender(msg), @date_time())
      signalfx_metric_attempt_result = @signalfx.SUCCESSFUL
      msg.send ":badger: moved from the wild to the care of #{message_sender(msg)}"
    else if @badger_owner_is_sender(msg)
      signalfx_metric_attempt_result = @signalfx.FAILED
      msg.send ":badger: is already in the care of #{@badger_owner()}"
    else
      @old_badger_owner = @badger_owner()
      @save_badger_info(message_sender(msg), @date_time())
      signalfx_metric_attempt_result = @signalfx.SUCCESSFUL
      msg.send ":badger: was stolen from #{@old_badger_owner} by #{message_sender(msg)}"

    @signalfx.send_metric("steal", message_sender(msg), signalfx_metric_attempt_result)

  take: (msg) ->
    if @badger_is_free()
      @save_badger_info(message_sender(msg), @date_time())
      signalfx_metric_attempt_result = @signalfx.SUCCESSFUL
      msg.send ":badger: moved from the wild to the care of #{message_sender(msg)}"
    else if @badger_owner_is_sender(msg)
      signalfx_metric_attempt_result = @signalfx.FAILED
      msg.send ":badger: is already in the care of #{@badger_owner()} since #{@badger_time()}"
    else
      signalfx_metric_attempt_result = @signalfx.FAILED
      msg.send "#{@badger_owner()} has had :badger: since #{@badger_time()}, go badger them"

    @signalfx.send_metric("take", message_sender(msg), signalfx_metric_attempt_result)

  where: (msg) ->
    if @badger_is_free()
      msg.send ":badger: is currently in the wild"
    else
      msg.send ":badger: is currently in the care of #{@badger_owner()} since #{@badger_time()}"

    @signalfx.send_metric("where", message_sender(msg), @signalfx.SUCCESSFUL)

  message_sender = (msg) ->
    msg.message.user.name.toLowerCase()


class SignalFX
  SUCCESSFUL: "successful"
  FAILED: "failed"

  constructor: ->
    signalfx = require("signalfx")
    @signalfx_client = new signalfx.Ingest(process.env.SIGNALFX_API_TOKEN)

  send_metric: (command, message_sender, attempt_result) ->
    metric_name = "badger.command"

    dimensions = {
      command: command,
      message_sender: message_sender,
      attempt_result: attempt_result
    }

    timestamp = new Date().getTime()

    metric = {
      metric: metric_name,
      value: 1,
      timestamp: timestamp,
      dimensions: dimensions
    }

    @signalfx_client.send({ counters:[metric] })


module.exports = (robot) ->
  badger = new Badger(robot)
  robot.hear /badger[ ]?take/i, (msg) -> badger.take(msg)
  robot.hear /badger[ ]?free/i, (msg) -> badger.free(msg)
  robot.hear /badger[ ]?where/i, (msg) -> badger.where(msg)
  robot.hear /badger[ ]?steal/i, (msg) -> badger.steal(msg)
