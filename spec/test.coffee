vows = require 'vows'
assert = require 'assert'
vows.describe('MetaTest').addBatch
  'test framwork checking':
    topic: 'test'
    'test':(topic)->
      assert.equal topic ,'test'
.export module


