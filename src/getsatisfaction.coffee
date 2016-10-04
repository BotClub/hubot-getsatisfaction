# Description:
#   Queries Get Satisfaction for information about topics
#
# Configuration:
#   HUBOT_GETSATISFACTION_COMPANY
#
# Commands:
#   hubot getsat search (topics) <QUERY> - returns a list of matching topics.
#   hubot getsat (all) ideas - returns the total count of all ideas.
#   hubot getsat company - returns the total count of all ideas.
#   hubot getsat company <COMPANY_NAME> - sets company_name.
#   hubot getsat help

sys = require 'sys' # Used for debugging
company_id = "#{process.env.HUBOT_GETSATISFACTION_COMPANY}"
queries =
  topics: "topics.json"
  ideas: "topics.json?style=idea&sort=most_me_toos"

company_url = (company_id, url) ->
  "companies/#{company_id}/#{url}"

company_web_link = () ->
  "[#{company_id}](http://getsatisfaction.com/#{company_id})"

topic_item = (topic) ->
  subject = topic.subject.replace /\*/g, '-'
  status = topic.status || 'none'
  style = topic.style.charAt(0).toUpperCase() + topic.style.slice(1);
  "* #{style} #{topic.id} (+#{topic.me_too_count}): [#{subject}](#{topic.at_sfn}) (#{status})\n"

uri_query_string = (params) ->
  pairs = []
  for k, v of params
    pairs.push "#{k}=#{v}"
  query = pairs.join("&")

filter_value = (k, v) ->
  filter_aliases = {
    "sort" : {
      "created" : "recently_created",
      "newest" : "recently_created",
      "active" : "recently_active",
      "replies" : "most_replies",
      "votes" : "most_me_toos"
    },
    "status" : {
      "closed" : "complete,rejected",
      "open" : "none,pending,active",
    }
  }
  if k of filter_aliases && v of filter_aliases[k]
    filter_aliases[k][v]
  else
    v

topics_query_robot_to_url = (query_robot) ->
  params = {}
  parts = query_robot.split(/\s+/)
  filter = /^([a-z]+):([a-z]+)$/i
  i_query_start = 0
  for word, i in parts
    i_query_start = i
    match = filter.exec(word);
    if match != null
      params[match[1]] = filter_value(match[1], match[2])
    else
      break
  if i < parts.length
    params['query'] = encodeURIComponent(parts.slice(i_query_start).join(" "))
  uri_query_string(params)

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

  robot.respond /(?:getsat|gs) help\s*$/i, (msg) ->
    msg.send "> See: [https://github.com/grokify/hubot-getsatisfaction](https://github.com/grokify/hubot-getsatisfaction)"

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
      content += topic_item(result) for result in results.data
      msg.send content

  robot.respond /(?:getsat|gs)\s+search\s+(?:topics\s+)?(\S.*)\s*$/i, (msg) ->
    query_robot = msg.match[1]
    query_params = topics_query_robot_to_url(query_robot)
    query_url = company_url(company_id, queries.topics) + '?' + query_params
    getsatisfaction_request msg, query_url, (results) ->
      company_link = company_web_link()
      content = "> #{results.total} #{company_link} topics for query: #{query_robot}\n"
      content += topic_item(result) for result in results.data
      msg.send content
