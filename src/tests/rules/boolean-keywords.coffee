###*
# @fileoverview This rule should require or disallow usage of specific boolean keywords.
# @author Julian Rosse
###
'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------

rule = require '../../rules/boolean-keywords'
{RuleTester} = require 'eslint'
path = require 'path'

error = (unexpected, replacement) ->
  if replacement?
    messageId: 'unexpected-fixable'
    data: {
      unexpected
      replacement
    }
  else
    messageId: 'unexpected'
    data: {
      unexpected
    }

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

ruleTester.run 'boolean-keywords', rule,
  valid: [
    code: 'yes or no'
    options: [allow: ['yes', 'no']]
  ,
    code: 'on or off'
    options: [allow: ['on', 'off']]
  ,
    code: 'true or false'
    options: [allow: ['true', 'false']]
  ,
    code: 'yes or no'
    options: [disallow: ['true', 'false']]
  ,
    code: 'yes or no'
    options: [disallow: ['on', 'off']]
  ,
    code: 'yes or no'
    options: [disallow: ['on', 'off', 'true']]
  ,
    code: 'on or off'
    options: [disallow: ['yes', 'no']]
  ,
    code: 'on or off'
    options: [disallow: ['true', 'false']]
  ,
    code: 'true'
    options: [disallow: ['yes', 'no']]
  ,
    code: 'false'
    options: [disallow: ['on', 'off']]
  ]

  invalid: [
    code: 'a is true'
    output: 'a is yes'
    options: [allow: ['yes', 'no']]
    errors: [error 'true', 'yes']
  ,
    code: 'a is true'
    output: 'a is yes'
    options: [disallow: ['true', 'false', 'on']]
    errors: [error 'true', 'yes']
  ,
    code: 'a is false'
    output: 'a is no'
    options: [allow: ['yes', 'no']]
    errors: [error 'false', 'no']
  ,
    code: 'a is false'
    output: 'a is no'
    options: [disallow: ['true', 'false', 'on', 'off']]
    errors: [error 'false', 'no']
  ,
    code: 'a is on'
    output: 'a is yes'
    options: [allow: ['yes', 'no']]
    errors: [error 'on', 'yes']
  ,
    code: 'a is on'
    output: 'a is yes'
    options: [disallow: ['true', 'false', 'on', 'off']]
    errors: [error 'on', 'yes']
  ,
    code: 'a is off'
    output: 'a is no'
    options: [allow: ['yes', 'no']]
    errors: [error 'off', 'no']
  ,
    code: 'a is off'
    output: 'a is no'
    options: [disallow: ['true', 'false', 'on', 'off']]
    errors: [error 'off', 'no']
  ,
    code: 'a and true'
    output: 'a and on'
    options: [allow: ['on', 'off']]
    errors: [error 'true', 'on']
  ,
    code: 'a and yes'
    output: 'a and true'
    options: [disallow: ['yes', 'no', 'on', 'off']]
    errors: [error 'yes', 'true']
  ,
    code: 'a and false'
    output: 'a and off'
    options: [allow: ['on', 'off']]
    errors: [error 'false', 'off']
  ,
    code: 'a and no'
    output: 'a and false'
    options: [disallow: ['yes', 'no', 'on', 'off']]
    errors: [error 'no', 'false']
  ,
    # can't fix when multiple allowed options
    code: 'false'
    output: 'false'
    options: [allow: ['yes', 'no', 'on', 'off']]
    errors: [error 'false']
  ,
    code: 'not false'
    output: 'not false'
    options: [disallow: ['true', 'false']]
    errors: [error 'false']
  ]
