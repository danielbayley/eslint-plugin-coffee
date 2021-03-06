###*
# @fileoverview Tests for no-restricted-globals.
# @author Benoît Zugmeyer
###

'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------

rule = require 'eslint/lib/rules/no-restricted-globals'
{RuleTester} = require 'eslint'
path = require 'path'

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

ruleTester.run 'no-restricted-globals', rule,
  valid: [
    'foo'
  ,
    code: 'foo'
    options: ['bar']
  ,
    code: 'foo = 1'
    options: ['foo']
  ,
    code: 'event'
    options: ['bar']
    env: browser: yes
  ,
    code: "import foo from 'bar'"
    options: ['foo']
    parserOptions: ecmaVersion: 6, sourceType: 'module'
  ,
    code: 'foo = ->'
    options: ['foo']
  ,
    code: 'foo.bar'
    options: ['bar']
  ,
    code: 'foo'
    options: [name: 'bar', message: 'Use baz instead.']
  ]
  invalid: [
    code: 'foo'
    options: ['foo']
    errors: [message: "Unexpected use of 'foo'.", type: 'Identifier']
  ,
    code: '-> foo'
    options: ['foo']
    errors: [message: "Unexpected use of 'foo'.", type: 'Identifier']
  ,
    code: '-> foo'
    options: ['foo']
    errors: [message: "Unexpected use of 'foo'.", type: 'Identifier']
    globals: foo: no
  ,
    code: 'event'
    options: ['foo', 'event']
    errors: [message: "Unexpected use of 'event'.", type: 'Identifier']
    env: browser: yes
  ,
    code: 'foo'
    options: ['foo']
    errors: [message: "Unexpected use of 'foo'.", type: 'Identifier']
    globals: foo: no
  ,
    code: 'foo()'
    options: ['foo']
    errors: [message: "Unexpected use of 'foo'.", type: 'Identifier']
  ,
    code: 'foo.bar()'
    options: ['foo']
    errors: [message: "Unexpected use of 'foo'.", type: 'Identifier']
  ,
    code: 'foo'
    options: [name: 'foo']
    errors: [message: "Unexpected use of 'foo'.", type: 'Identifier']
  ,
    code: '-> foo'
    options: [name: 'foo']
    errors: [message: "Unexpected use of 'foo'.", type: 'Identifier']
  ,
    code: '-> foo'
    options: [name: 'foo']
    errors: [message: "Unexpected use of 'foo'.", type: 'Identifier']
    globals: foo: no
  ,
    code: 'event'
    options: ['foo', {name: 'event'}]
    errors: [message: "Unexpected use of 'event'.", type: 'Identifier']
    env: browser: yes
  ,
    code: 'foo'
    options: [name: 'foo']
    errors: [message: "Unexpected use of 'foo'.", type: 'Identifier']
    globals: foo: no
  ,
    code: 'foo()'
    options: [name: 'foo']
    errors: [message: "Unexpected use of 'foo'.", type: 'Identifier']
  ,
    code: 'foo.bar()'
    options: [name: 'foo']
    errors: [message: "Unexpected use of 'foo'.", type: 'Identifier']
  ,
    code: 'foo'
    options: [name: 'foo', message: 'Use bar instead.']
    errors: [
      message: "Unexpected use of 'foo'. Use bar instead.", type: 'Identifier'
    ]
  ,
    code: '-> foo'
    options: [name: 'foo', message: 'Use bar instead.']
    errors: [
      message: "Unexpected use of 'foo'. Use bar instead.", type: 'Identifier'
    ]
  ,
    code: '-> foo'
    options: [name: 'foo', message: 'Use bar instead.']
    errors: [
      message: "Unexpected use of 'foo'. Use bar instead.", type: 'Identifier'
    ]
    globals: foo: no
  ,
    code: 'event'
    options: ['foo', {name: 'event', message: 'Use local event parameter.'}]
    errors: [
      message: "Unexpected use of 'event'. Use local event parameter."
      type: 'Identifier'
    ]
    env: browser: yes
  ,
    code: 'foo'
    options: [name: 'foo', message: 'Use bar instead.']
    errors: [
      message: "Unexpected use of 'foo'. Use bar instead.", type: 'Identifier'
    ]
    globals: foo: no
  ,
    code: 'foo()'
    options: [name: 'foo', message: 'Use bar instead.']
    errors: [
      message: "Unexpected use of 'foo'. Use bar instead.", type: 'Identifier'
    ]
  ,
    code: 'foo.bar()'
    options: [name: 'foo', message: 'Use bar instead.']
    errors: [
      message: "Unexpected use of 'foo'. Use bar instead.", type: 'Identifier'
    ]
  ,
    code: "foo = (obj) => hasOwnProperty(obj, 'name')"
    options: ['hasOwnProperty']
    errors: [message: "Unexpected use of 'hasOwnProperty'.", type: 'Identifier']
  ]
