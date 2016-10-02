# hubot-getsatisfaction

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
hubot getsat (all) ideas - returns the total count of all ideas.
hubot getsat company - returns the total count of all ideas.
hubot getsat company <COMPANY_NAME> - sets company_name.
```

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
