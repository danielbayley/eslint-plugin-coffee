###*
# @fileoverview Tests for constructor-super rule.
# @author Toru Nagashima
###

'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------

rule = require 'eslint/lib/rules/constructor-super'
{RuleTester} = require 'eslint'
path = require 'path'

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

ruleTester.run 'constructor-super', rule,
  valid: [
    # non derived classes.
    '''
      class A
    '''
    '''
      class A
        constructor: ->
    '''

    ###
    # inherit from non constructors.
    # those are valid if we don't define the constructor.
    ###
    '''
      class A extends null
    '''

    # derived classes.
    '''
      class A extends B
    '''
    '''
      class A extends B
        constructor: -> super()
    '''
    '''
      class A extends B
        constructor: ->
          if true
            super()
          else
            super()
    '''
    '''
      class A extends (class B)
        constructor: -> super()
    '''
    '''
      class A extends (B = C)
        constructor: -> super()
    '''
    '''
      class A extends (B or C)
        constructor: -> super()
    '''
    '''
      class A extends (if a then B else C)
        constructor: -> super()
    '''
    '''
      class A extends (B; C)
        constructor: -> super()
    '''

    # nested.
    '''
      class A
        constructor: ->
          class B extends C
            constructor: ->
              super()
    '''
    '''
      class A extends B
        constructor: ->
          super()
          class C extends D
            constructor: -> super()
    '''
    '''
      class A extends B
        constructor: ->
          super()
          class C
            constructor: ->
    '''

    # ignores out of constructors.
    '''
      class A
        b: -> super()
    '''

    # multi code path.
    '''
      class A extends B
        constructor: ->
          if a then super() else super()
    '''
    '''
      class A extends B
        constructor: ->
          if a
            super()
          else
            super()
    '''
    '''
      class A extends B
        constructor: ->
          switch a
            when 0, 1
              super()
            else
              super()
    '''
    '''
      class A extends B
        constructor: ->
          try
          finally
            super()
    '''
    '''
      class A extends B
        constructor: ->
          if a
            throw Error()
          super()
    '''

    # returning value is a substitute of 'super()'.
    '''
      class A extends B
        constructor: ->
          return a if yes
          super()
    '''
    '''
      class A extends null
        constructor: ->
          return a
    '''
    '''
      class A
        constructor: ->
          return a
    '''

    # https://github.com/eslint/eslint/issues/5261
    '''
      class A extends B
        constructor: (a) ->
          super()
          for b from a
            @a()
    '''

    # https://github.com/eslint/eslint/issues/5319
    '''
      class Foo extends Object
        constructor: (method) ->
          super()
          @method = method or ->
    '''

    # # https://github.com/eslint/eslint/issues/5894
    # '''
    #   class A
    #     constructor: ->
    #       return
    #       super()
    # '''

    # https://github.com/eslint/eslint/issues/8848
    '''
      class A extends B
        constructor: (props) ->
            super props

            try
              arr = []
              for a from arr
                ;
            catch err
    '''
  ]
  invalid: [
    # # non derived classes.
    # code: '''
    #   class A
    #     constructor: -> super()
    # '''
    # errors: [messageId: 'unexpected', type: 'CallExpression']
    # ,
    # inherit from non constructors.
    code: '''
      class A extends null
        constructor: ->
          super()
    '''
    errors: [messageId: 'badSuper', type: 'CallExpression']
  ,
    code: '''
      class A extends null
        constructor: ->
    '''
    errors: [messageId: 'missingAll', type: 'MethodDefinition']
  ,
    code: '''
      class A extends 100
        constructor: -> super()
    '''
    errors: [messageId: 'badSuper', type: 'CallExpression']
  ,
    code: '''
      class A extends 'test'
        constructor: -> super()
    '''
    errors: [messageId: 'badSuper', type: 'CallExpression']
  ,
    # derived classes.
    code: '''
      class A extends B
        constructor: ->
    '''
    errors: [messageId: 'missingAll', type: 'MethodDefinition']
  ,
    code: '''
      class A extends B
        constructor: ->
          for a from b
            super.foo()
    '''
    errors: [messageId: 'missingAll', type: 'MethodDefinition']
  ,
    # nested execution scope.
    code: '''
      class A extends B
        constructor: ->
          c = -> super()
    '''
    errors: [messageId: 'missingAll', type: 'MethodDefinition']
  ,
    code: '''
      class A extends B
        constructor: ->
          c = => super()
    '''
    errors: [messageId: 'missingAll', type: 'MethodDefinition']
  ,
    code: '''
      class A extends B
        constructor: ->
          class C extends D
            constructor: -> super()
    '''
    errors: [messageId: 'missingAll', type: 'MethodDefinition', line: 2]
  ,
    code: '''
      class A extends B
        constructor: ->
          C = class extends D
            constructor: -> super()
    '''
    errors: [messageId: 'missingAll', type: 'MethodDefinition', line: 2]
  ,
    code: '''
      class A extends B
        constructor: ->
          super()
          class C extends D
            constructor: ->
    '''
    errors: [messageId: 'missingAll', type: 'MethodDefinition', line: 5]
  ,
    code: '''
      class A extends B
        constructor: ->
          super()
          C = class extends D
            constructor: ->
    '''
    errors: [messageId: 'missingAll', type: 'MethodDefinition', line: 5]
  ,
    # lacked in some code path.
    code: '''
      class A extends B
        constructor: ->
          if a
            super()
    '''
    errors: [messageId: 'missingSome', type: 'MethodDefinition']
  ,
    code: '''
      class A extends B
        constructor: ->
          if a
            ;
          else super()
    '''
    errors: [messageId: 'missingSome', type: 'MethodDefinition']
  ,
    code: '''
      class A extends B
        constructor: ->
          a and super()
    '''
    errors: [messageId: 'missingSome', type: 'MethodDefinition']
  ,
    code: '''
      class A extends B
        constructor: ->
          switch a
            when 0
              super()
    '''
    errors: [messageId: 'missingSome', type: 'MethodDefinition']
  ,
    code: '''
      class A extends B
        constructor: ->
          switch a
            when 0
              ;
            else
              super()
    '''
    errors: [messageId: 'missingSome', type: 'MethodDefinition']
  ,
    code: '''
      class A extends B
        constructor: ->
          try
            super()
          catch err
    '''
    errors: [messageId: 'missingSome', type: 'MethodDefinition']
  ,
    code: '''
      class A extends B
        constructor: ->
          try
            a
          catch err
            super()
    '''
    errors: [messageId: 'missingSome', type: 'MethodDefinition']
  ,
    code: '''
      class A extends B
        constructor: ->
          return if a
          super()
    '''
    errors: [messageId: 'missingSome', type: 'MethodDefinition']
  ,
    # duplicate.
    code: '''
      class A extends B
        constructor: ->
          super()
          super()
    '''
    errors: [messageId: 'duplicate', type: 'CallExpression', line: 4]
  ,
    code: '''
      class A extends B
        constructor: ->
          super() or super()
    '''
    errors: [
      messageId: 'duplicate', type: 'CallExpression', line: 3, column: 16
    ]
  ,
    code: '''
      class A extends B
        constructor: ->
          super() ? super()
    '''
    errors: [
      messageId: 'duplicate', type: 'CallExpression', line: 3, column: 15
    ]
  ,
    code: '''
      class A extends B
        constructor: ->
          super() if a
          super()
    '''
    errors: [messageId: 'duplicate', type: 'CallExpression', line: 4]
  ,
    code: '''
      class A extends B
        constructor: (a) ->
          while a
            super()
    '''
    errors: [
      messageId: 'missingSome', type: 'MethodDefinition'
    ,
      messageId: 'duplicate', type: 'CallExpression', line: 4
    ]
  ,
    # ignores `super()` on unreachable paths.
    code: '''
      class A extends B
        constructor: ->
          return
          super()
    '''
    errors: [messageId: 'missingAll', type: 'MethodDefinition']
  ,
    # https://github.com/eslint/eslint/issues/8248
    code: '''
      class Foo extends Bar
        constructor: ->
          for a of b
            for c of d
              ;
    '''
    errors: [messageId: 'missingAll', type: 'MethodDefinition']
  ]
