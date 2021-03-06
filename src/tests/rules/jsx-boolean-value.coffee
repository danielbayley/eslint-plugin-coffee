###*
# @fileoverview Enforce boolean attributes notation in JSX
# @author Yannick Croissant
###
'use strict'

# ------------------------------------------------------------------------------
# Requirements
# ------------------------------------------------------------------------------

rule = require '../../rules/jsx-boolean-value'
{RuleTester} = require 'eslint'
path = require 'path'

# ------------------------------------------------------------------------------
# Tests
# ------------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'
ruleTester.run 'jsx-boolean-value', rule,
  valid: [
    code: '<App foo />', options: ['never']
  ,
    code: '<App foo bar={true} />', options: ['always', {never: ['foo']}]
  ,
    code: '<App foo bar={yes} />', options: ['always', {never: ['foo']}]
  ,
    code: '<App foo bar={on} />', options: ['always', {never: ['foo']}]
  ,
    code: '<App foo />'
  ,
    code: '<App foo={true} />', options: ['always']
  ,
    code: '<App foo={yes} />', options: ['always']
  ,
    code: '<App foo={on} />', options: ['always']
  ,
    code: '<App foo={true} bar />', options: ['never', {always: ['foo']}]
  ,
    code: '<App foo={yes} bar />', options: ['never', {always: ['foo']}]
  ,
    code: '<App foo={on} bar />', options: ['never', {always: ['foo']}]
  ]
  invalid: [
    code: '<App foo={true} />'
    output: '<App foo />'
    options: ['never']
    errors: [message: 'Value must be omitted for boolean attributes']
  ,
    code: '<App foo={on} />'
    output: '<App foo />'
    options: ['never']
    errors: [message: 'Value must be omitted for boolean attributes']
  ,
    code: '<App foo={yes} />'
    output: '<App foo />'
    options: ['never']
    errors: [message: 'Value must be omitted for boolean attributes']
  ,
    code: '<App foo={true} bar={true} baz={true} />'
    output: '<App foo bar baz={true} />'
    options: ['always', {never: ['foo', 'bar']}]
    errors: [
      message:
        'Value must be omitted for boolean attributes for the following props: `foo`, `bar`'
    ,
      message:
        'Value must be omitted for boolean attributes for the following props: `foo`, `bar`'
    ]
  ,
    code: '<App foo={true} />'
    output: '<App foo />'
    errors: [message: 'Value must be omitted for boolean attributes']
  ,
    code: '<App foo = {true} />'
    output: '<App foo />'
    errors: [message: 'Value must be omitted for boolean attributes']
  ,
    code: '<App foo />'
    output: '<App foo={true} />'
    options: ['always']
    errors: [message: 'Value must be set for boolean attributes']
  ,
    code: '<App foo bar baz />'
    output: '<App foo={true} bar={true} baz />'
    options: ['never', {always: ['foo', 'bar']}]
    errors: [
      message:
        'Value must be set for boolean attributes for the following props: `foo`, `bar`'
    ,
      message:
        'Value must be set for boolean attributes for the following props: `foo`, `bar`'
    ]
  ]
