### eslint-env jest ###
###*
# @fileoverview Enforce lang attribute has a valid value.
# @author Ethan Cohen
###

# -----------------------------------------------------------------------------
# Requirements
# -----------------------------------------------------------------------------

path = require 'path'
{RuleTester} = require 'eslint'
{
  default: parserOptionsMapper
} = require '../eslint-plugin-jsx-a11y-parser-options-mapper'
rule = require 'eslint-plugin-jsx-a11y/lib/rules/lang'

# -----------------------------------------------------------------------------
# Tests
# -----------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

expectedError =
  message: 'lang attribute must have a valid value.'
  type: 'JSXAttribute'

ruleTester.run 'lang', rule,
  valid: [
    code: '<div />'
  ,
    code: '<div foo="bar" />'
  ,
    code: '<div lang="foo" />'
  ,
    code: '<html lang="en" />'
  ,
    code: '<html lang="en-US" />'
  ,
    code: '<html lang={foo} />'
  ,
    code: '<HTML lang="foo" />'
  ,
    code: '<Foo lang="bar" />'
  ].map parserOptionsMapper
  invalid: [
    code: '<html lang="foo" />', errors: [expectedError]
  ,
    code: '<html lang="zz-LL" />', errors: [expectedError]
  ,
    code: '<html lang={undefined} />', errors: [expectedError]
  ].map parserOptionsMapper
