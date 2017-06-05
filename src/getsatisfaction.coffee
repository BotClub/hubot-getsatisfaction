# Description:
#   Queries Get Satisfaction for information about topics
#
# Configuration:
#   HUBOT_GETSATISFACTION_COMPANY
#
# Commands:
#   hubot getsat search (topics) (filter) <QUERY> - returns a list of matching topics.
#   hubot getsat (all) ideas - returns the total count of all ideas.
#   hubot getsat company - returns the total count of all ideas.
#   hubot getsat company <COMPANY_NAME> - sets company_name.
#   hubot getsat help

sys = require 'sys' # Used for debugging
company_id = "#{process.env.HUBOT_GETSATISFACTION_COMPANY}"
view = "#{process.env.HUBOT_GETSATISFACTION_VIEW}"
queries =
  topics: "topics.json"
  ideas: "topics.json?style=idea&sort=most_me_toos"

company_url = (company_id, url) ->
  "companies/#{company_id}/#{url}"

company_web_link = (robot) ->
  build_link robot, "http://getsatisfaction.com/#{company_id}", company_id

topic_item = (robot, topic) ->
  subject = topic.subject.replace /\*/g, '-'
  status = topic.status || 'none'
  style = topic.style.charAt(0).toUpperCase() + topic.style.slice(1)
  author = build_link robot, topic.author.at_sfn, topic.author.name
  topic_link = build_link robot, topic.at_sfn, subject
  "* #{style} #{topic.id} (+#{topic.me_too_count}): #{topic_link} by #{author} (#{status})\n"

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
  k = k.toLowerCase()
  v = v.toLowerCase()
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
    match = filter.exec(word)
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

build_link = (robot, url, text) ->
  if ! text
    text = url
  ct = robot_content_type(robot)
  if ct == 'markdown'
    return "[#{text}](#{url})"
  else
    return "<#{url}|#{text}>"

faster_safer_mod = (n, base) ->
  unless (jsmod = n % base) and ((n > 0) != (base > 0)) then jsmod
  else jsmod + base

style_to_emoji = (style) ->
  style2emoji = {
    "idea" : ":bulb:",
    "problem" : ":warning:",
    "question" : ":question:",
    "praise" : ":heart:",
    "update" : ":arrows_counterclockwise:"
  }
  emoji = ":question:"
  style = style.toLowerCase()
  if style of style2emoji
    emoji = style2emoji[style]
  return emoji

format_date_nice = (date) ->
  dt = new Date(date)
  mn_name = month_name(dt.getMonth())
  "#{mn_name} #{dt.getDate()}, #{dt.getFullYear()}"

robot_content_type = (robot) ->
  views = { "json" : 1, "markdown" : 1 }
  if views.key? view.toLowerCase()
    return view.toLowerCase()
  else if robot.adapterName == 'glip'
    return 'markdown'
  else
    return 'json'

month_name = (month) ->
  month_names = ["January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ]
  return month_names[month]

topics_content = (robot, style, query_robot, results) ->
  ct = robot_content_type(robot)
  if ct == 'json'
    return topics_content_json(robot, style, query_robot, results)
  else
    return topics_content_markdown(robot, style, query_robot, results)

topics_content_markdown = (robot, style, query_robot, results) ->
  company_link = company_web_link(robot)
  items = style
  if items == 'topics'
    items += " for query: #{query_robot}\n"
  else
    items += "\n"
  content = "> #{results.total} #{company_link} #{items}\n"
  content += topic_item(robot, result) for result in results.data
  return content

topics_content_json = (robot, style, query_robot, results) ->
  company_link = company_web_link(robot)
  items = style
  if items == 'topics'
    items += " for query: `#{query_robot}`\n"
  else
    items += "\n"
  attachments = []
  attachments.push {
    pretext: "#{results.total} #{company_link} #{items}",
    mrkdwn_in: ["pretext"]
  }
  i = 0
  for topic in results.data
    status = topic.status || 'no status'
    emoji = style_to_emoji(topic.style)
    date = format_date_nice(topic.last_active_at)
    item = {
      author_name: "#{emoji} #{topic.author.name} - #{date}",
      author_link: topic.author.at_sfn,
      title: "#{topic.subject} (+#{topic.me_too_count}, #{status})",
      title_link: topic.at_sfn
    }
    modulo = faster_safer_mod(i, 2)
    if modulo == 0
      item['color'] = '#ff8800'
    else
      item['color'] = '#0073ae'
    i = i + 1
    attachments.push item
  body = {
    attachments: attachments
  }
  return body

module.exports = (robot) ->

  robot.respond /(?:getsat|gs) help\s*$/i, (msg) ->
    url = "https://github.com/grokify/hubot-getsatisfaction"
    link = build_link(robot, url)
    message = "**Commands**\n" + 
      "> hubot getsat search (topics) (filter) <QUERY> - returns a list of matching topics.\n" +
      "> hubot getsat (all) ideas - returns the total count of all ideas.\n" +
      "> hubot getsat company - returns the total count of all ideas.\n"+ 
      "> hubot getsat company <COMPANY_NAME> - sets company_name.\n" +
      "> hubot getsat help\n" +
      "**Filters**\n" +
      "> sort: votes, newest, active, replies, unanswered. votes is an alias for most_me_toos\n" +
      "> style: question, problem, praise, idea, update\n" +
      "> status: none, pending, active, complete, rejected, open, closed. open and closed are meta values. open = none or pending or active, closed = complete or rejected\n" +
      "**Notes**\n" +
      "> `gs` can be substituted for `getsat`, e.g. `hubot gs search sort:votes glip\n" +
      "> For more, see #{link}"
    msg.send message

  robot.respond /(?:getsat|gs) company\s*$/i, (msg) ->
    company_link = company_web_link(robot)
    msg.send "> Using Get Satisfaction company: #{company_link}"

  robot.respond /(?:getsat|gs) company\s+(\S+)\s*$/i, (msg) ->
    company_id = msg.match[1]
    company_link = company_web_link(robot)
    msg.send "> Get Satisfaction Company set to: #{company_link}"

  robot.respond /(?:getsat|gs) (all )?ideas$/i, (msg) ->
    query_url = company_url(company_id, queries.ideas)
    getsatisfaction_request msg, query_url, (results) ->
      topic_count = results.total
      company_link = company_web_link(robot)
      msg.send "> #{topic_count} ideas for: #{company_link}"

  robot.respond /(?:getsat|gs)\s+list\s+ideas$/i, (msg) ->
    query_url = company_url(company_id, queries.ideas)
    getsatisfaction_request msg, query_url, (results) ->
      msg.send topics_content robot, 'ideas', '', results

  robot.respond /(?:getsat|gs)\s+search\s+(?:topics\s+)?(\S.*)\s*$/i, (msg) ->
    query_robot = msg.match[1]
    query_params = topics_query_robot_to_url(query_robot)
    query_url = company_url(company_id, queries.topics) + '?' + query_params
    getsatisfaction_request msg, query_url, (results) ->
      msg.send topics_content robot, 'topics', query_robot, results
