###*
# @fileoverview Tests for jsx-fragments
# @author Alex Zherdev
###

'use strict'

# ------------------------------------------------------------------------------
# Requirements
# ------------------------------------------------------------------------------

path = require 'path'
{RuleTester} = require 'eslint'
rule = require '../../rules/jsx-fragments'

# parsers = require 'eslint-plugin-react/tests/helpers/parsers'

# parserOptions = {}
#   ecmaVersion: 2018
#   sourceType: 'module'
#   ecmaFeatures:
#     jsx: yes

settings =
  react:
    version: '16.2'
    pragma: 'Act'
    fragment: 'Frag'

settingsOld =
  react:
    version: '16.1'
    pragma: 'Act'
    fragment: 'Frag'

# ------------------------------------------------------------------------------
# Tests
# ------------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'
ruleTester.run 'jsx-fragments', rule,
  valid: [
    {
      code: '<><Foo /></>'
      # parser: parsers.BABEL_ESLINT
      settings
    }
    {
      code: '<Act.Frag><Foo /></Act.Frag>'
      options: ['element']
      settings
    }
    {
      code: '<Act.Frag />'
      options: ['element']
      settings
    }
    {
      code: '''
        import Act, { Frag as F } from 'react'
        <F><Foo /></F>
      '''
      options: ['element']
      settings
    }
    {
      code: '''
        F = Act.Frag
        <F><Foo /></F>
      '''
      options: ['element']
      settings
    }
    {
      code: '''
        { Frag } = Act
        <Frag><Foo /></Frag>
      '''
      options: ['element']
      settings
    }
    {
      code: '''
        { Frag } = require('react')
        <Frag><Foo /></Frag>
      '''
      options: ['element']
      settings
    }
    {
      code: '<Act.Frag key="key"><Foo /></Act.Frag>'
      options: ['syntax']
      settings
    }
    {
      code: '<Act.Frag key="key" />'
      options: ['syntax']
      settings
    }
  ]

  invalid: [
    code: '<><Foo /></>'
    # parser: parsers.BABEL_ESLINT
    settings: settingsOld
    errors: [
      message:
        'Fragments are only supported starting from React v16.2. ' +
        'Please disable the `react/jsx-fragments` rule in ESLint settings or upgrade your version of React.'
    ]
  ,
    code: '<Act.Frag><Foo /></Act.Frag>'
    settings: settingsOld
    errors: [
      message:
        'Fragments are only supported starting from React v16.2. ' +
        'Please disable the `react/jsx-fragments` rule in ESLint settings or upgrade your version of React.'
    ]
  ,
    code: '<Act.Frag />'
    settings: settingsOld
    errors: [
      message:
        'Fragments are only supported starting from React v16.2. ' +
        'Please disable the `react/jsx-fragments` rule in ESLint settings or upgrade your version of React.'
    ]
  ,
    {
      code: '<><Foo /></>'
      # parser: parsers.BABEL_ESLINT
      options: ['element']
      settings
      errors: [message: 'Prefer Act.Frag over fragment shorthand']
      output: '<Act.Frag><Foo /></Act.Frag>'
    }
    {
      code: '<Act.Frag><Foo /></Act.Frag>'
      options: ['syntax']
      settings
      errors: [message: 'Prefer fragment shorthand over Act.Frag']
      output: '<><Foo /></>'
    }
    {
      code: '<Act.Frag />'
      options: ['syntax']
      settings
      errors: [message: 'Prefer fragment shorthand over Act.Frag']
      output: '<></>'
    }
    {
      code: '''
        import Act, { Frag as F } from 'react'
        <F />
      '''
      options: ['syntax']
      settings
      errors: [message: 'Prefer fragment shorthand over Act.Frag']
      output: '''
        import Act, { Frag as F } from 'react'
        <></>
      '''
    }
    {
      code: '''
        import Act, { Frag as F } from 'react'
        <F><Foo /></F>
      '''
      options: ['syntax']
      settings
      errors: [message: 'Prefer fragment shorthand over Act.Frag']
      output: '''
        import Act, { Frag as F } from 'react'
        <><Foo /></>
      '''
    }
    {
      code: '''
        import Act, { Frag } from 'react'
        <Frag><Foo /></Frag>
      '''
      options: ['syntax']
      settings
      errors: [message: 'Prefer fragment shorthand over Act.Frag']
      output: '''
        import Act, { Frag } from 'react'
        <><Foo /></>
      '''
    }
    {
      code: '''
        F = Act.Frag
        <F><Foo /></F>
      '''
      options: ['syntax']
      settings
      errors: [message: 'Prefer fragment shorthand over Act.Frag']
      output: '''
        F = Act.Frag
        <><Foo /></>
      '''
    }
    {
      code: '''
        { Frag } = Act
        <Frag><Foo /></Frag>
      '''
      options: ['syntax']
      settings
      errors: [message: 'Prefer fragment shorthand over Act.Frag']
      output: '''
        { Frag } = Act
        <><Foo /></>
      '''
    }
    {
      code: '''
        { Frag } = require('react')
        <Frag><Foo /></Frag>
      '''
      options: ['syntax']
      settings
      errors: [message: 'Prefer fragment shorthand over Act.Frag']
      output: '''
        { Frag } = require('react')
        <><Foo /></>
      '''
    }
  ]
