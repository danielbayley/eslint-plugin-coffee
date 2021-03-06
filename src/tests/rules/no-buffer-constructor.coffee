###*
# @fileoverview disallow use of the Buffer() constructor
# @author Teddy Katz
###
'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------

rule = require 'eslint/lib/rules/no-buffer-constructor'
{RuleTester} = require 'eslint'
path = require 'path'

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------

CALL_ERROR =
  messageId: 'deprecated'
  data:
    expr: 'Buffer()'
  type: 'CallExpression'
CONSTRUCT_ERROR =
  messageId: 'deprecated'
  data:
    expr: 'new Buffer()'
  type: 'NewExpression'

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

ruleTester.run 'no-buffer-constructor', rule,
  valid: [
    'Buffer.alloc(5)'
    'Buffer.allocUnsafe(5)'
    'new Buffer.Foo()'
    'Buffer.from([1, 2, 3])'
    'foo(Buffer)'
    'Buffer.alloc(res.body.amount)'
    'Buffer.from(res.body.values)'
  ]

  invalid: [
    code: 'Buffer(5)'
    errors: [CALL_ERROR]
  ,
    code: 'new Buffer(5)'
    errors: [CONSTRUCT_ERROR]
  ,
    code: 'Buffer([1, 2, 3])'
    errors: [CALL_ERROR]
  ,
    code: 'new Buffer([1, 2, 3])'
    errors: [CONSTRUCT_ERROR]
  ,
    code: 'new Buffer(res.body.amount)'
    errors: [CONSTRUCT_ERROR]
  ,
    code: 'new Buffer(res.body.values)'
    errors: [CONSTRUCT_ERROR]
  ]
