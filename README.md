# hubot-getsatisfaction

![Hubot Get Satisfaction](docs/images/hubot_getsatisfaction.png)

Hubot Get Satisfaction handler script to query topics by company.

[![NPM Version][npm-image]][npm-url]
[![Code Climate][codeclimate-status-svg]][codeclimate-status-link]
[![Scrutinizer Code Quality][scrutinizer-status-svg]][scrutinizer-status-link]
[![NPM Downloads][downloads-image]][downloads-url]
[![License][license-svg]][license-link]

[![Stories in Ready][story-status-svg]][story-status-link]

See [`src/getsatisfaction.coffee`](src/getsatisfaction.coffee) for full documentation.

This Hubot script supports JSON and Markdown views. which can be set using an environment variable or using adapter-based defaults.

## Installation

In hubot project repo, run:

`npm install hubot-getsatisfaction --save`

Then add **hubot-getsatisfaction** to your `external-scripts.json`:

```json
["hubot-getsatisfaction"]
```

You can also add `hubot-getsatisfaction` to your `package.json` file and then run `npm install`.

## Configuration

| Variable | Required | Description |
|----------|----------|-------------|
| `HUBOT_GETSATISFACTION_COMPANY` | Yes | API Company Name URL Slug, e.g. `ringcentraldev` |
| `HUBOT_GETSATISFACTION_VIEW` | No | Enumerated value [`json`,`markdown`]. Use `markdown` for Glip and `json` for Slack. |

## Usage

### Commands

Both keywords `getsat` and `gs` are used.

```
hubot getsat search (topics) (filter) <QUERY> - returns a list of matching topics.
hubot getsat (all) ideas - returns the total count of all ideas.
hubot getsat company - returns the total count of all ideas.
hubot getsat company <COMPANY_NAME> - sets company_name.
hubot getsat help
```

For more information on using filters, see the next section.

### Search Topics

To search topics you can use the following topic filters which must be placed ahead of your query. For example `hubot getsat search topics sort:votes style:idea glip`.

| Filter | Values | Notes |
|--------|--------|-------|
| `sort` | `votes, newest, active, replies, unanswered` | `votes` is an alias for `most_me_toos` |
| `style` | `question, problem, praise, idea, update` | |
| `status` | `none, pending, active, complete, rejected, open, closed` | `open` and `closed` are meta values. `open` = `none or pending or active`, `closed` = `complete or rejected` |

More information on filters is available here: [https://education.getsatisfaction.com/reference-guide/api/api-resources/](https://education.getsatisfaction.com/reference-guide/api/api-resources/).

### Example Usage

Create a Hubot instance, add `hubot-getsatisfaction` to `external-scripts.json` and start.

The following example uses the [`hubot-glip` adapter](https://github.com/tylerlong/hubot-glip).

```bash
$ mkdir myhubot
$ cd myhubot
$ yo hubot
$ vi external-scripts.json
$ HUBOT_GLIP_SERVER=https://platform.ringcentral.com \
HUBOT_GLIP_APP_KEY=MyGlipAppKey \
HUBOT_GLIP_APP_SECRET=MyGlipAppSecret \
HUBOT_GLIP_USERNAME=16505550123
HUBOT_GLIP_EXTENSION=102
HUBOT_GLIP_PASSWORD=MyUserPassword
HUBOT_GETSATISFACTION_COMPANY=ringcentral \
HUBOT_GETSATISFACTION_VIEW=markdown \
./bin/hubot -n hubot -a glip
```

![Hubot Get Satisfaction Demo](docs/images/hubot_getsatisfaction_demo_glip_ringcentral-ringcentraldev_500x.png)

## Links

Project Repo

* https://github.com/grokify/hubot-getsatisfaction

Ready-to-Deploy version with Heroku One-Button Deployment

* https://github.com/grokify/glipbot-getsatisfaction

Hubot

* https://github.com/github/hubot

Get Satisfaction API

* API Reference: https://education.getsatisfaction.com/reference-guide/api/
* API Specs: https://github.com/grokify/api-specs/tree/master/specs/getsatisfaction

## Contributing

1. Fork it ( http://github.com/grokify/hubot-getsatisfaction/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Hubot Get Satisfaction script is available under the MIT license. See [LICENSE.md](LICENSE.md) for details.

Hubot Get Satisfaction script &copy; 2016 by John Wang

 [npm-image]: https://img.shields.io/npm/v/hubot-getsatisfaction.svg
 [npm-url]: https://npmjs.org/package/hubot-getsatisfaction
 [codeclimate-status-svg]: https://codeclimate.com/github/grokify/hubot-getsatisfaction/badges/gpa.svg
 [codeclimate-status-link]: https://codeclimate.com/github/grokify/hubot-getsatisfaction
 [scrutinizer-status-svg]: https://scrutinizer-ci.com/g/grokify/hubot-getsatisfaction/badges/quality-score.png?b=master
 [scrutinizer-status-link]: https://scrutinizer-ci.com/g/grokify/hubot-getsatisfaction/?branch=master
 [downloads-image]: https://img.shields.io/npm/dm/hubot-getsatisfaction.svg
 [downloads-url]: https://npmjs.org/package/hubot-getsatisfaction
 [story-status-svg]: https://badge.waffle.io/grokify/hubot-getsatisfaction.svg?label=ready&title=Ready
 [story-status-link]: https://waffle.io/grokify/hubot-getsatisfaction
 [license-svg]: https://img.shields.io/badge/license-MIT-blue.svg
 [license-link]: https://github.com/grokify/hubot-getsatisfaction/blob/master/LICENSE.md
