# Description:
#   Queries Get Satisfaction for information about topics
#
# Configuration:
#   HUBOT_GETSATISFACTION_COMPANY
#
# Commands:
#   hubot getsat (all) ideas - returns the total count of all ideas.
#   hubot getsat company - returns the total count of all ideas.
#   hubot getsat company <COMPANY_NAME> - sets company_name.

sys = require 'sys' # Used for debugging
company_id = "#{process.env.HUBOT_GETSATISFACTION_COMPANY}"
queries =
  ideas: "topics.json?style=idea&sort=most_me_toos"

company_url = (company_id, url) ->
  "companies/#{company_id}/#{url}"

company_web_link = () ->
  "[#{company_id}](http://getsatisfaction.com/#{company_id})"

topic_item = (topic) ->
  "#{topic.id} (+#{topic.me_too_count}): [#{topic.subject}](#{topic.at_sfn})\n"

getsatisfaction_request = (msg, url, handler) ->
  getsatisfaction_url = "https://api.getsatisfaction.com"

  msg.http("#{getsatisfaction_url}/#{url}")
    .get() (err, res, body) ->
      if err
        msg.send "Get Satisfaction says: #{err}"
        return

      content = JSON.parse(body)

      if content.error?
        if content.error?.title
          msg.send "Get Satisfaction says: #{content.error.title}"
        else
          msg.send "Get Satisfaction says: #{content.error}"
        return

      handler content

module.exports = (robot) ->

  robot.respond /(?:getsat|gs) company\s*$/i, (msg) ->
    company_link = company_web_link()
    msg.send "> Using Get Satisfaction company: #{company_link}"

  robot.respond /(?:getsat|gs) company\s+(\S+)\s*$/i, (msg) ->
    company_id = msg.match[1]
    company_link = company_web_link()
    msg.send "> Get Satisfaction Company set to: #{company_link}"

  robot.respond /(?:getsat|gs) (all )?ideas$/i, (msg) ->
    query_url = company_url(company_id, queries.ideas)
    getsatisfaction_request msg, query_url, (results) ->
      topic_count = results.total
      company_link = company_web_link()
      msg.send "> #{topic_count} ideas for: #{company_link}"

  robot.respond /(?:getsat|gs)\s+list\s+ideas$/i, (msg) ->
    query_url = company_url(company_id, queries.ideas)
    getsatisfaction_request msg, query_url, (results) ->
      company_link = company_web_link()
      content = "> #{results.total} ideas for: #{company_link}\n"
      for result in results.data
        line = topic_item(result)
        content += "* Idea #{line}"
      msg.send content
