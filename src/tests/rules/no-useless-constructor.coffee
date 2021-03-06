###*
# @fileoverview Tests for no-useless-constructor rule.
# @author Alberto Rodriguez
###

'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------

rule = require '../../rules/no-useless-constructor'
{RuleTester} = require 'eslint'
path = require 'path'

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'
error = message: 'Useless constructor.', type: 'MethodDefinition'

ruleTester.run 'no-useless-constructor', rule,
  valid: [
    'class A'
    '''
      class A
        constructor: ->
          doSomething()
    '''
    '''
      class A extends B
        constructor: ->
          super 'foo'
    '''
    '''
      class A extends B
        constructor: ->
    '''
    '''
      class A extends B
        constructor: ->
          super('foo')
    '''
    '''
      class A extends B
        constructor: (foo, bar) -> super(foo, bar, 1)
    '''
    '''
      class A extends B
        constructor: ->
          super()
          doSomething()
    '''
    '''
      class A extends B
        constructor: (...args) ->
          super(...args)
          doSomething()
    '''
    '''
      class A
        dummyMethod: ->
          doSomething()
    '''
    '''
      class A extends B.C
        constructor: ->
          super(foo)
    '''
    '''
      class A extends B.C
        constructor: ([a, b, c]) ->
          super(...arguments)
    '''
    '''
      class A extends B.C
        constructor: (a = f()) ->
          super(...arguments)
    '''
    '''
      class A extends B
        constructor: (a, b, c) ->
          super(a, b)
    '''
    '''
      class A extends B
        constructor: (foo, bar) ->
          super(foo)
    '''
    '''
      class A extends B
        constructor: (test) ->
          super()
    '''
    '''
      class A extends B
        constructor: ->
          foo
    '''
    '''
      class A extends B
        constructor: (foo, bar) ->
          super(bar)
    '''
    '''
      class A
        constructor: (@foo) ->
    '''
    '''
      class A
        constructor: ([@foo]) ->
    '''
    '''
      class A
        constructor: ({@foo}) ->
    '''
    '''
      class A
        constructor: ([{@foo}]) ->
    '''
    '''
      class A
        constructor: (@foo = 1) ->
    '''
    '''
      class A
        constructor: ([@foo = 1]) ->
    '''
    '''
      class A
        constructor: ({@foo = 1}) ->
    '''
    '''
      class A
        constructor: ([{@foo = 1}]) ->
    '''
    '''
      class A
        constructor: ({foo: @bar = 1}) ->
    '''
  ]
  invalid: [
    code: '''
      class A
        constructor: ->
    '''
    errors: [error]
  ,
    code: '''
      class A
        'constructor': ->
    '''
    errors: [error]
  ,
    code: '''
      class A extends B
        constructor: ->
          super()
    '''
    errors: [error]
  ,
    code: '''
      class A extends B
        constructor: (foo) ->
          super foo
    '''
    errors: [error]
  ,
    code: '''
      class A extends B
        constructor: (foo, bar) ->
          super(foo, bar)
    '''
    errors: [error]
  ,
    code: '''
      class A extends B
        constructor: (...args) ->
          super(...args)
    '''
    errors: [error]
  ,
    code: '''
      class A extends B.C
        constructor: ->
          super(...arguments)
    '''
    errors: [error]
  ,
    code: '''
      class A extends B
        constructor: (a, b, ...c) ->
          super(...arguments)
    '''
    errors: [error]
  ,
    code: '''
      class A extends B
        constructor: (a, b, ...c) ->
          super(a, b, ...c)
    '''
    errors: [error]
  ]
