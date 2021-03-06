###*
# @fileoverview require default when in switch statements
# @author Aliaksei Shytkin
###
'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------

rule = require 'eslint/lib/rules/default-case'
{RuleTester} = require 'eslint'
path = require 'path'

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

ruleTester.run 'default-case', rule,
  valid: [
    '''
      switch a
        when 1
          break
        else
          break
    '''
    '''
      switch a
        when 1, 2
          break
        else
          break
    '''
    '''
      switch a
        when 1
          break
        else
          break
        #no default
    '''
    '''
      switch a
        when 1
          break
        #oh-oh
        # no default
    '''
    '''
      switch a
        when 1
          ;
        # no default
    '''
    '''
      switch a
        when 1 then ;
        # No default
    '''
    '''
      switch a
        when 1
          ;
        # no deFAUlt
    '''
    '''
      switch a
        when 1
          ;
        # NO DEFAULT
    '''
    '''
      switch a
        when 1
          a = 4

        # no default
    '''
    '''
      switch a
        when 1
          a = 4

        ### no default ###
    '''
    '''
      switch a
        when 1
          a = 4
          break
          break

        # no default
    '''
  ,
    code: '''
        switch a
          when 1
            break
          else
            break
      '''
    options: [commentPattern: 'default case omitted']
  ,
    code: '''
        switch a
          when 1 then break
          # skip default case
      '''
    options: [commentPattern: '^skip default']
  ,
    code: '''
        switch a
          when 1
            break

          ###
          TODO:
           throw error in default case
          ###
      '''
    options: [commentPattern: 'default']
  ,
    code: '''
        switch a
          when 1
            break
          #
      '''
    options: [commentPattern: '.?']
  ]

  invalid: [
    code: '''
      switch a
        when 1
          break
    '''
    errors: [
      messageId: 'missingDefaultCase'
      type: 'SwitchStatement'
    ]
  ,
    code: '''
        switch a
          # no default
          when 1
            break
      '''
    errors: [
      messageId: 'missingDefaultCase'
      type: 'SwitchStatement'
    ]
  ,
    code: '''
        switch a
          when 1
            break
          # no default
          # nope
      '''
    errors: [
      messageId: 'missingDefaultCase'
      type: 'SwitchStatement'
    ]
  ,
    code: '''
        switch a
          when 1
            break
          # no default
      '''
    options: [commentPattern: 'skipped default case']
    errors: [
      messageId: 'missingDefaultCase'
      type: 'SwitchStatement'
    ]
  ,
    code: '''
        switch a
          when 1
            break
          # default omitted intentionally
          # TODO: add default case
      '''
    options: [commentPattern: 'default omitted']
    errors: [
      messageId: 'missingDefaultCase'
      type: 'SwitchStatement'
    ]
  ,
    code: '''
        switch a
          when 1
            break
      '''
    options: [commentPattern: '.?']
    errors: [
      messageId: 'missingDefaultCase'
      type: 'SwitchStatement'
    ]
  ]
