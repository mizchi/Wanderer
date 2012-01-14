require.paths.unshift(path.join(__dirname, '..'))
vows = require 'vows'
assert = require 'assert'

vows.describe('BattleTest').addBatch
  'test framework meta test':
    assert.True true

.export module


