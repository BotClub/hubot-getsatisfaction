# hubot-getsatisfaction

![Hubot Get Satisfaction](docs/images/hubot_getsatisfaction.png)

Queries Get Satisfaction for information about support tickets

See [`src/getsatisfaction.coffee`](src/getsatisfaction.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-getsatisfaction --save`

Then add **hubot-getsatisfaction** to your `external-scripts.json`:

```json
["hubot-getsatisfaction"]
```

## Configuration
```
HUBOT_GETSATISFACTION_COMPANY=API Company Name URL Slug
```

## Usage
```
hubot getsat search topics <QUERY> - returns a list of matching topics.
hubot getsat (all) ideas - returns the total count of all ideas.
hubot getsat company - returns the total count of all ideas.
hubot getsat company <COMPANY_NAME> - sets company_name.
```

### Search Topics

To search topics you can use the following topic filters which must be placed ahead of your query. For example `hubot getsat search topics sort:votes style:idea glip`.

| filter | values |
|--------|--------|
| `sort` | `votes, newest, active, replies, unanswered` |
| `style` | `question, problem, praise, idea, update` |
| `status` | `none, pending, active, complete, rejected` |

### Example Usage

Create a Hubot instance, add `hubot-getsatisfaction` to `external-scripts.json` and start.

The following example uses the [`hubot-glip` adapter](https://github.com/tylerlong/hubot-glip).

```bash
$ mkdir myhubot
$ cd myhubot
$ yo hubot
$ vi external-scripts.json
$ HUBOT_GLIP_HOST=glip.com \
HUBOT_GLIP_EMAIL=hubot@example.com \
HUBOT_GLIP_PASSWORD=MySecretPassword \
HUBOT_GETSATISFACTION_COMPANY=ringcentraldev ./bin/hubot -n hubot -a glip
```

![Hubot Get Satisfaction Demo](docs/images/hubot_getsatisfaction_demo_glip.png.png)

## Links

Project Repo

* https://github.com/grokify/hubot-getsatisfaction

Hubot

* https://github.com/github/hubot

Get Satisfaction API

* https://education.getsatisfaction.com/reference-guide/api/

## Contributing

1. Fork it ( http://github.com/grokify/hubot-getsatisfaction/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Hubot Get Satisfaction script is available under the MIT license. See [LICENSE.md](LICENSE.md) for details.

Hubot Get Satisfaction script &copy; 2016 by John Wang
