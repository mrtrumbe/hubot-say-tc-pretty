# Description:
#   Post
#   This script listens for build notifications from a TeamCity instance
#   configured with tcWebhooks. The script listens for pushes at path 
#   /hubot/build/. Payload is expected to be a json object, with used
#   properties described below.
#   
#   This script uses hubot-say-it-pretty, specifically the sayitpretty event.
#
#   Configure which rooms the script sends messages to using
#   HUBOT_SAY_TC_PRETTY_ROOMS. This is required and can be a single room name
#   or a comma-separated list of room names.
#
#   See more information on tcWebHooks here: 
#   http://tcplugins.sourceforge.net/info/tcWebHooks
#
# Dependencies:
#   hubot-say-it-pretty
#
# Configuration:
#   HUBOT_SAY_TC_PRETTY_ROOMS
#
# Commands:
#   None
#
# Notes:
#   The following properties from the json payload are used:
#   
# Author:
#   mrtrumbe

TextMessage = require('hubot').TextMessage

module.exports = (robot)->
  robot.router.post "/hubot/build/", (req, res)->
    success = (msg) ->
      res.end msg

    error = (msg, err) ->
      res.end msg
    
    #robot.emit "sayitpretty", req.body, success, error
    console.log req.body
    res.end "done."
