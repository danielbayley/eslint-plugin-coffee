###*
# @fileoverview Prefer or disallow explicit parens for functions with no parameters.
# @author Julian Rosse
###
'use strict'

# ------------------------------------------------------------------------------
# Requirements
# ------------------------------------------------------------------------------

rule = require '../../rules/empty-func-parens'
{RuleTester} = require 'eslint'
path = require 'path'

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

USE_PARENS = message: 'Use empty parentheses for function parameter list'
DONT_USE_PARENS =
  message: "Don't use parentheses for empty function parameter list"

# ------------------------------------------------------------------------------
# Tests
# ------------------------------------------------------------------------------

ruleTester.run 'empty-func-parens', rule,
  valid: [
    '->'
    '(a) ->'
    'do ->'
    '''
      a = ->
        x()
    '''
    'a() ->'
    'a(->)'
    '=> ->'
    '''
      class A
        b: ->
    '''
  ,
    code: '() ->'
    options: ['always']
  ,
    code: 'do () ->'
    options: ['always']
  ,
    code: '''
      a = () ->
        x()
    '''
    options: ['always']
  ,
    code: 'a() () ->'
    options: ['always']
  ,
    code: 'a(() ->)'
    options: ['always']
  ,
    code: '''
      class A
        b: () ->
    '''
    options: ['always']
  ]
  invalid: [
    code: '->'
    options: ['always']
    errors: [USE_PARENS]
  ,
    code: 'do ->'
    options: ['always']
    errors: [USE_PARENS]
  ,
    code: '''
      a = ->
        x()
    '''
    options: ['always']
    errors: [USE_PARENS]
  ,
    code: 'a() ->'
    options: ['always']
    errors: [USE_PARENS]
  ,
    code: 'a(->)'
    options: ['always']
    errors: [USE_PARENS]
  ,
    code: '=> ->'
    options: ['always']
    errors: [USE_PARENS, USE_PARENS]
  ,
    code: '''
      class A
        b: ->
    '''
    options: ['always']
    errors: [USE_PARENS]
  ,
    code: '() ->'
    errors: [DONT_USE_PARENS]
  ,
    code: 'do () ->'
    options: ['never']
    errors: [DONT_USE_PARENS]
  ,
    code: '''
      a = () ->
        x()
    '''
    errors: [DONT_USE_PARENS]
  ,
    code: 'a() () ->'
    errors: [DONT_USE_PARENS]
  ,
    code: 'a(() ->)'
    errors: [DONT_USE_PARENS]
  ,
    code: '() => () ->'
    errors: [DONT_USE_PARENS, DONT_USE_PARENS]
  ,
    code: '''
      class A
        b: () ->
    '''
    errors: [DONT_USE_PARENS]
  ]
