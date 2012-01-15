vows = require 'vows'
assert = require 'assert'
sinon = require 'sinon'

class Twitter
  tweet: (message) ->

vows.describe('VowsTest').addBatch
  'test framwork checking':
    topic: 'test'
    'equal':(topic)->
      assert.equal topic ,'test'

    'isTrue':(topic)->
      assert.isTrue topic is 'test'

    'sinon mock':(topic)->
      twitter = new Twitter()
      twitterMock = sinon.mock(twitter)
      twitterMock.expects("tweet").once().withArgs("hello")
      twitter.tweet("hello")
      twitterMock.verify()
      
    teardown: (topic) ->


.export module


