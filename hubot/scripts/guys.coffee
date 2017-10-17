# Description
#   Guys
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   guys
#
# Notes:
#   None
#
# Author:
#   aylya
#

guys_links = [
  "https://www.huffingtonpost.com/michael-jascz/why-we-should-stop-callin_b_8091436.html",
  "https://mic.com/articles/115090/guys-can-we-stop-calling-everyone-guys-already",
  "http://mashable.com/2016/06/02/stop-saying-hey-guys/"
]

module.exports = (robot) ->
  robot.hear /(guys\b|Guys)/i, (msg) ->
    msg.send msg.random guys_links
