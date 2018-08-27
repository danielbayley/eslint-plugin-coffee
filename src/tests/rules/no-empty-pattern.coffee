###*
# @fileoverview Tests for no-empty-pattern rule.
# @author Alberto Rodríguez
###
'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------

rule = require 'eslint/lib/rules/no-empty-pattern'
{RuleTester} = require 'eslint'

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------

ruleTester = new RuleTester parser: '../../..'

ruleTester.run 'no-empty-pattern', rule,
  # Examples of code that should not trigger the rule
  valid: [
    '{a = {}} = foo'
    '{a, b = {}} = foo'
    '{a = []} = foo'
    '({a = {}}) ->'
    '({a = []}) ->'
    '[a] = foo'
  ]

  # Examples of code that should trigger the rule
  invalid: [
    code: '{} = foo'
    errors: [
      messageId: 'unexpected'
      data: type: 'object'
      type: 'ObjectPattern'
    ]
  ,
    code: '[] = foo'
    errors: [
      messageId: 'unexpected'
      data: type: 'array'
      type: 'ArrayPattern'
    ]
  ,
    code: '{a: {}} = foo'
    errors: [
      messageId: 'unexpected'
      data: type: 'object'
      type: 'ObjectPattern'
    ]
  ,
    code: '{a, b: {}} = foo'
    errors: [
      messageId: 'unexpected'
      data: type: 'object'
      type: 'ObjectPattern'
    ]
  ,
    code: '{a: []} = foo'
    errors: [
      messageId: 'unexpected'
      data: type: 'array'
      type: 'ArrayPattern'
    ]
  ,
    code: '({}) ->'
    errors: [
      messageId: 'unexpected'
      data: type: 'object'
      type: 'ObjectPattern'
    ]
  ,
    code: '([]) ->'
    errors: [
      messageId: 'unexpected'
      data: type: 'array'
      type: 'ArrayPattern'
    ]
  ,
    code: 'foo = ({a: {}}) ->'
    errors: [
      messageId: 'unexpected'
      data: type: 'object'
      type: 'ObjectPattern'
    ]
  ,
    code: '({a: []}) ->'
    errors: [
      messageId: 'unexpected'
      data: type: 'array'
      type: 'ArrayPattern'
    ]
  ]