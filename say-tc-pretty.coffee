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
#   The payload must contain a property build, which should be an object with properties:
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
  rooms = process.env.HUBOT_SAY_TC_PRETTY_ROOMS
  if rooms
    rooms = rooms.trim().split(',')
    if rooms.length == 0
      rooms = null
      robot.logger.error "say-tc-pretty needs a room configured in the HUBOT_SAY_TC_PRETTY_ROOMS env variable."
      return
  else
    robot.logger.error "say-tc-pretty needs a room configured in the HUBOT_SAY_TC_PRETTY_ROOMS env variable."
    return


  robot.router.post "/hubot/build/", (req, res)->
    success = (msg) ->
      res.end msg

    error = (msg, err) ->
      res.end msg

    build = req.body.build
    unless build
      res.end "json payload doesn't have a build property. cannot. go. on."
      return

    if not build.buildName or not build.buildResult or not build.projectName
      res.end "build object doesn't have buildName, buildResult, or projectName. cannot. go. on."
      return

    bn = build.projectName.trim() + '(' + build.buildName.trim() + ')'
    
    title = null
    if build.buildResult.trim() != 'success'
      title = 'Build of ' + bn ' Failed!'
      buildSuccess = false
    else
      buildSuccess = true
      if not build.buildResultPrevious || build.buildResultPrevious.trim() == 'success'
        title = 'Build of ' + bn ' Succeeded!'
      else
        title = 'Success! Build of ' + bn + ' Fixed.'

    if build.buildNumber
      head = 'Build #' + build.buildNumber.trim() + ' '
    else
      head = 'Built '

    if build.agentName
      head = head + ' on agent ' + build.agentName.trim() + ' '

    if build.triggeredBy
      head = head + ' triggered by ' + build.triggeredBy.trim()

    if head == ''
      head = undefined
    else
      head = head + '.'

    message = undefined
    if not buildSuccess and build.buildStatus
      message = 'Status: ' + build.buildStatus.trim()
    
    for room in rooms
      command = {
        room: room,
        title: title,
        head: head,
        message: message
      }
    
      robot.emit "sayitpretty", command, success, error
