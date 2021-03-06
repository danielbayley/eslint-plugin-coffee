###*
# @fileoverview Tests for no-extra-boolean-cast rule.
# @author Brandon Mills
###

'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------

rule = require '../../rules/no-extra-boolean-cast'
{RuleTester} = require 'eslint'
path = require 'path'

#------------------------------------------------------------------------------
# Helpers
#------------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

ruleTester.run 'no-extra-boolean-cast', rule,
  valid: [
    'foo = !!bar'
    '-> !!bar'
    'foo = if bar() then !!baz else !!bat'
    'foo = Boolean(bar)'
    '-> return Boolean(bar)'
    'foo = if bar() then Boolean(baz) else Boolean(bat)'
    'if (new Boolean(foo)) then ;'
  ]

  invalid: [
    code: 'if (!!foo) then ;'
    # output: 'if (foo) then ;'
    errors: [
      messageId: 'unexpectedNegation'
      type: 'UnaryExpression'
    ]
  ,
    code: 'while (!!foo) then ;'
    # output: 'while (foo) then ;'
    errors: [
      messageId: 'unexpectedNegation'
      type: 'UnaryExpression'
    ]
  ,
    code: 'if !!foo then bar else baz'
    # output: 'if foo then bar else baz'
    errors: [
      messageId: 'unexpectedNegation'
      type: 'UnaryExpression'
    ]
  ,
    code: '!!!foo'
    # output: '!foo'
    errors: [
      messageId: 'unexpectedNegation'
      type: 'UnaryExpression'
    ]
  ,
    code: 'Boolean(!!foo)'
    # output: 'Boolean(foo)'
    errors: [
      messageId: 'unexpectedNegation'
      type: 'UnaryExpression'
    ]
  ,
    code: 'new Boolean(!!foo)'
    # output: 'new Boolean(foo)'
    errors: [
      messageId: 'unexpectedNegation'
      type: 'UnaryExpression'
    ]
  ,
    code: 'if (Boolean(foo)) then ;'
    # output: 'if (foo) then ;'
    errors: [
      messageId: 'unexpectedCall'
      type: 'CallExpression'
    ]
  ,
    code: 'while (Boolean(foo)) then ;'
    # output: 'while (foo) then ;'
    errors: [
      messageId: 'unexpectedCall'
      type: 'CallExpression'
    ]
  ,
    code: 'if Boolean foo then bar else baz'
    # output: 'if foo then bar else baz'
    errors: [
      messageId: 'unexpectedCall'
      type: 'CallExpression'
    ]
  ,
    code: '!Boolean foo'
    # output: '!foo'
    errors: [
      messageId: 'unexpectedCall'
      type: 'CallExpression'
    ]
  ,
    code: '!Boolean(foo and bar)'
    # output: '!(foo and bar)'
    errors: [
      messageId: 'unexpectedCall'
      type: 'CallExpression'
    ]
  ,
    code: '!Boolean(foo + bar)'
    # output: '!(foo + bar)'
    errors: [
      messageId: 'unexpectedCall'
      type: 'CallExpression'
    ]
  ,
    code: '!Boolean(+foo)'
    # output: '!+foo'
    errors: [
      messageId: 'unexpectedCall'
      type: 'CallExpression'
    ]
  ,
    code: '!Boolean(foo())'
    # output: '!foo()'
    errors: [
      messageId: 'unexpectedCall'
      type: 'CallExpression'
    ]
  ,
    code: '!Boolean(foo = bar)'
    # output: '!(foo = bar)'
    errors: [
      messageId: 'unexpectedCall'
      type: 'CallExpression'
    ]
  ,
    code: '!Boolean(...foo)'
    # output: null
    errors: [
      messageId: 'unexpectedCall'
      type: 'CallExpression'
    ]
  ,
    code: '!Boolean(foo; bar())'
    # output: null
    errors: [
      messageId: 'unexpectedCall'
      type: 'CallExpression'
    ]
  ,
    code: '!Boolean((foo; bar()))'
    # output: '!(foo; bar())'
    errors: [
      messageId: 'unexpectedCall'
      type: 'CallExpression'
    ]
  ,
    code: '!Boolean()'
    # output: 'true'
    errors: [
      messageId: 'unexpectedCall'
      type: 'CallExpression'
    ]
  ,
    code: '!(Boolean())'
    # output: 'true'
    errors: [
      messageId: 'unexpectedCall'
      type: 'CallExpression'
    ]
  ]
