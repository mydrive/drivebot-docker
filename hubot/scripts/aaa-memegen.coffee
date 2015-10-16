# Description:
#   Integrates with MyDrive's meme generator
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot <text> ALL the <things> - Generates ALL THE THINGS
#   hubot (Oh|You) <text> (Please|Tell) <text> - Condescending Wonka
#   hubot Ermahgerd <text> - Ermahgerd
#   hubot Not sure if <text> or <text> - Futurama Fry
#   hubot I don't always <something> but when i do <text> - The Most Interesting man in the World
#   hubot one does not simply <text> - Lord of the Rings Boromir
#   hubot <text> ORLY? - ORLY? owl with the top caption of <text>
#   hubot <text> (SUCCESS|NAILED IT) - success kid with the top caption of <text>
#   hubot Yo dawg <text> so <text> - Yo Dawg
#   hubot Y U NO <text>  - Y U NO GUY with the bottom caption of <text>
# Author:
#   gavinheavyside


inspect = require('util').inspect

module.exports = (robot) ->
  unless robot.brain.data.memes?
    robot.brain.data.memes = [
      {
        regex: /(image me )?(.*) (ALL THE .*)/i,
        top: 2,
        bottom: 3,
        image: 'allthethings'
      },
      {
        regex: /((Oh|You) .*) ((Please|Tell) .*)/i,
        top: 1,
        bottom: 3,
        image: 'condescendingwonka'
      },
      {
        regex: /(Ermahgerd) (.*)/i,
        top: 1,
        bottom: 2,
        image: 'ermahgerd'
      },
      {
        regex: /(NOT SURE IF .*) (OR .*)/i,
        top: 1,
        bottom: 2,
        image: 'futuramafry'
      },
      {
        regex: /(.*) (WTF\?)/i,
        top: 1,
        bottom: 2,
        image: 'koala'
      },
      {
        regex: /(I DON'?T ALWAYS .*) (BUT WHEN I DO,? .*)/i,
        top: 1,
        bottom: 2,
        image: 'mostinterestingman'
      },
      {
        regex: /(one does not simply) (.*)/i,
        top: 1,
        bottom: 2,
        image: 'onedoesnotsimply'
      },
      {
        regex: /(.*) (O\s?RLY\??.*)/i,
        top: 1,
        bottom: 2,
        image: 'orly'
      },
      {
        regex: /(.*) (SUCCESS|NAILED IT.*)/i,
        top: 1,
        bottom: 2,
        image: 'successkid'
      },
      {
        regex: /(YO DAWG .*) (SO .*)/i,
        top: 1,
        bottom: 2,
        image: 'xzibit'
      },
      {
        regex: /(Y U NO) (.+)/i,
        top: 1,
        bottom: 2,
        image: 'yunoguy'
      }
    ]

  for meme in robot.brain.data.memes
    memeResponder robot, meme


memeResponder = (robot, meme) ->
  robot.respond meme.regex, (msg) ->
    top = msg.match[meme.top].replace(/\ /g, '_').replace(/\?/g, '%3F')
    bottom = msg.match[meme.bottom].replace(/\ /g, '_').replace(/\?/g, '%3F')

    msg.send "http://mydrive-memes.herokuapp.com/#{top}/#{bottom}/#{meme.image}.jpg"
    msg.finish()
