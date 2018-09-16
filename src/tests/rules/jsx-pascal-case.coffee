###*
# @fileoverview Tests for jsx-pascal-case
# @author Jake Marsh
###
'use strict'

# ------------------------------------------------------------------------------
# Requirements
# ------------------------------------------------------------------------------

rule = require 'eslint-plugin-react/lib/rules/jsx-pascal-case'
{RuleTester} = require 'eslint'

# ------------------------------------------------------------------------------
# Tests
# ------------------------------------------------------------------------------

ruleTester = new RuleTester parser: '../../..'
ruleTester.run 'jsx-pascal-case', rule,
  valid: [
    code: '<testComponent />'
  ,
    code: '<test_component />'
  ,
    code: '<TestComponent />'
  ,
    code: '<CSSTransitionGroup />'
  ,
    code: '<BetterThanCSS />'
  ,
    code: '<TestComponent><div /></TestComponent>'
  ,
    code: '<Test1Component />'
  ,
    code: '<TestComponent1 />'
  ,
    code: '<T3stComp0nent />'
  ,
    code: '<T />'
  ,
    code: '<YMCA />'
    options: [allowAllCaps: yes]
  ,
    code: '<Modal.Header />'
  ,
    # ,
    #   code: '<Modal:Header />'
    code: '<IGNORED />'
    options: [ignore: ['IGNORED']]
  ]

  invalid: [
    code: '<Test_component />'
    errors: [
      message: 'Imported JSX component Test_component must be in PascalCase'
    ]
  ,
    code: '<TEST_COMPONENT />'
    errors: [
      message: 'Imported JSX component TEST_COMPONENT must be in PascalCase'
    ]
  ,
    code: '<YMCA />'
    errors: [message: 'Imported JSX component YMCA must be in PascalCase']
  ]
