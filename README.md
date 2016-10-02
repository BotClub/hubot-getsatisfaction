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
