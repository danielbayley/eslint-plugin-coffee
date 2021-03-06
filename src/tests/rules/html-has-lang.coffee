### eslint-env jest ###
###*
# @fileoverview Enforce html element has lang prop.
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
rule = require 'eslint-plugin-jsx-a11y/lib/rules/html-has-lang'

# -----------------------------------------------------------------------------
# Tests
# -----------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

expectedError =
  message: '<html> elements must have the lang prop.'
  type: 'JSXOpeningElement'

ruleTester.run 'html-has-lang', rule,
  valid: [
    code: '<div />'
  ,
    code: '<html lang="en" />'
  ,
    code: '<html lang="en-US" />'
  ,
    code: '<html lang={foo} />'
  ,
    code: '<html lang />'
  ,
    code: '<HTML />'
  ].map parserOptionsMapper
  invalid: [
    code: '<html />', errors: [expectedError]
  ,
    code: '<html {...props} />', errors: [expectedError]
  ,
    code: '<html lang={undefined} />', errors: [expectedError]
  ].map parserOptionsMapper
