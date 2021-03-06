###*
# @fileoverview Tests for max-depth.
# @author Ian Christian Myers
###

'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------

rule = require '../../rules/max-depth'
{RuleTester} = require 'eslint'
path = require 'path'

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

ruleTester.run 'max-depth', rule,
  valid: [
    code: '''
      foo = ->
        if true
          if false
            if true
              ;
    '''
    options: [3]
  ,
    code: '''
      ->
        if yes
          ;
        else if no
          ;
        else if yes
          ;
        else if no
          ;
    '''
    options: [3]
  ,
    # object property options
    code: '''
      foo = ->
        if true
          if false
            if true
              ;
    '''
    options: [max: 3]
  ]
  invalid: [
    code: '''
      foo = ->
        if true
          if false
            if true
              ;
    '''
    options: [2]
    errors: [message: 'Blocks are nested too deeply (3).', type: 'IfStatement']
  ,
    code: '''
      ->
        if yes
          ;
        else
          loop
            ;
    '''
    options: [1]
    errors: [
      message: 'Blocks are nested too deeply (2).', type: 'WhileStatement'
    ]
  ,
    code: '''
      ->
        loop
          if true
            ;
    '''
    options: [1]
    errors: [message: 'Blocks are nested too deeply (2).', type: 'IfStatement']
  ,
    code: '''
      foo = ->
        for x from foo
          if true
            ;
    '''
    options: [1]
    errors: [message: 'Blocks are nested too deeply (2).', type: 'IfStatement']
  ,
    code: '''
      ->
        while yes
          if yes
            if no
              ;
    '''
    options: [1]
    errors: [
      message: 'Blocks are nested too deeply (2).', type: 'IfStatement'
    ,
      message: 'Blocks are nested too deeply (3).', type: 'IfStatement'
    ]
  ,
    code: '''
      ->
        if true
          if false
            if true
              if false
                if true
                  ;
    '''
    errors: [message: 'Blocks are nested too deeply (5).', type: 'IfStatement']
  ,
    # object property options
    code: '''
      ->
        if yes
          if no
            if yes
              ;
    '''
    options: [max: 2]
    errors: [message: 'Blocks are nested too deeply (3).', type: 'IfStatement']
  ]
