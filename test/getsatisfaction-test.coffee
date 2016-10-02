chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'getsatisfaction', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/getsatisfaction')(@robot)

  it 'registers a respond listener for all ideas count', ->
    expect(@robot.respond).to.have.been.calledWith(/(?:getsat|gs) (all )?ideas$/i)

  it 'registers a respond listener for ideas list', ->
    expect(@robot.respond).to.have.been.calledWith(/(?:getsat|gs) list ideas$/i)

  it 'registers a respond listener for company setting', ->
    expect(@robot.respond).to.have.been.calledWith(/(?:getsat|gs) company$/i)

  it 'registers a respond listener for new company', ->
    expect(@robot.respond).to.have.been.calledWith(/(?:getsat|gs) company (\S+)$/i)
