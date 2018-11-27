# Description
#   :build_monitor: cycler/interface
#
# Dependencies:
#   hubot-redis-brain
#
# Configuration:
#   None
#
# Commands:
#   build_monitor add    - Add a build monitor to the build monitor list
#   build_monitor remove - Remove a build monitor from the build monitor list
#   build_monitor take   - Become the build monitor
#   build_monitor next   - Move to the next build monitor
#   build_monitor who    - Who is the build monitor now?
#
# Notes:
#   The build_monitor can only be taken by one person.
#
#   The build monitor is responsible for handling any build issues.
#
#   A build issue is:
#     1. Any issue that prevents a developer from passing CI
#        for reasons that do not relate to their current changes
#     2. Any issue that occurs in build intermittently
#
#   Handling includes prioritisaion.
#
#
# Authors:
#   willfish

class BuildMonitor
  constructor: (robot) ->
    @robot = robot

  add: (res) ->
    monitors = this.monitors()
    monitor = res.match[1]
    length = monitors.push(monitor)
    @robot.brain.set("monitors", monitors)
    res.send("Total monitors count is now #{length}")

  remove: (res) ->
    current = this.current_monitor()
    monitors = this.monitors()
    monitor = res.match[1]
    monitor_index = monitors.indexOf(monitor)

    if (index > -1)
      monitors.splice(index, 1)

    @robot.brain.set("monitors", monitors)

    res.send "Total monitors count is now #{monitors.length}"
    res.send "Removed #{monitor.length}"

    if current == monitor
      this.next(res)

  next: (res) ->
    monitors = this.monitors()
    current = this.current_monitor()
    index = monitors.indexOf(current_monitor)

    next_monitor = if (monitors.length - 1 >= index)
      monitors[0]
    else
      monitors[index + 1]

    @robot.brain.set("current_monitor", next_monitor)

    res.send "Old monitor was #{current}"
    res.send "New monitor is #{next_monitor}"

  who: (res) ->
    res.send "Current monitor is #{this.current_monitor()}"
  list: (res) ->
    res.send "Monitors are #{this.monitors()}"

  current_monitor: -> @robot.brain.get("current_monitor")
  monitors: -> @robot.brain.get("monitors") || []
  start_time: -> @robot.brain.get("monitor_start_time") || ""

module.exports = (robot) ->
  monitor = new BuildMonitor(robot)

  robot.hear /monitor[ ]?add (.*)/i, (res) -> monitor.add(res)
  robot.hear /monitor[ ]?remove (.*)/i, (res) -> monitor.remove(res)
  robot.hear /monitor[ ]?next/i, (res) -> monitor.next(res)
  robot.hear /monitor[ ]?who/i, (res) -> monitor.who(res)
  robot.hear /monitor[ ]?list/i, (res) -> monitor.list(res)
