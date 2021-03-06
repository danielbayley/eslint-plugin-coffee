###*
# @fileoverview Tests for max-classes-per-file rule.
# @author James Garbutt <https://github.com/43081j>
###
'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------

rule = require 'eslint/lib/rules/max-classes-per-file'
{RuleTester} = require 'eslint'
path = require 'path'

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

ruleTester.run 'max-classes-per-file', rule,
  valid: [
    'class Foo'
    'x = class'
    'x = 5'
  ,
    code: 'class Foo'
    options: [1]
  ,
    code: '''
      class Foo
      class Bar
    '''
    options: [2]
  ]

  invalid: [
    code: '''
      class Foo
      class Bar
    '''
    errors: [messageId: 'maximumExceeded', type: 'Program']
  ,
    code: '''
      x = class
      y = class
    '''
    errors: [messageId: 'maximumExceeded', type: 'Program']
  ,
    code: '''
      class Foo
      x = class
    '''
    errors: [messageId: 'maximumExceeded', type: 'Program']
  ,
    code: '''
      class Foo
      class Bar
    '''
    options: [1]
    errors: [messageId: 'maximumExceeded', type: 'Program']
  ,
    code: '''
      class Foo
      class Bar
      class Baz
    '''
    options: [2]
    errors: [messageId: 'maximumExceeded', type: 'Program']
  ]
