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
#   agentName - The name of the agent that did the built. Optional.
#   buildName - Which project build configuration is being built. Required.
#   buildNumber - Which build number is this? Optional.
#   buildResult - Looking for 'success'. Anything else is considered a failure. Required.
#   buildResultPrevious - Same as buildResult, but for the last build. Optional.
#   buildStatus - Any last words from the build server on how the build went down. Optional.
#   projectName - The name of the project being built. Required.
#   triggeredBy - Who or what triggered the build? Optional.
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
    for prop in req.body.teamcityProperties
        consol.log prop

    res.end "done."
