### eslint-env jest ###
###*
# @fileoverview Enforce no accesskey attribute on element.
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
rule = require 'eslint-plugin-jsx-a11y/lib/rules/no-access-key'

# -----------------------------------------------------------------------------
# Tests
# -----------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

expectedError =
  message:
    'No access key attribute allowed. Inconsistencies between keyboard shortcuts and keyboard comments used by screenreader and keyboard only users create a11y complications.'
  type: 'JSXOpeningElement'

### eslint-disable coffee/no-template-curly-in-string ###

ruleTester.run 'no-access-key', rule,
  valid: [
    code: '<div />'
  ,
    code: '<div {...props} />'
  ,
    code: '<div accessKey={undefined} />'
  ].map parserOptionsMapper
  invalid: [
    code: '<div accesskey="h" />', errors: [expectedError]
  ,
    code: '<div accessKey="h" />', errors: [expectedError]
  ,
    code: '<div accessKey="h" {...props} />', errors: [expectedError]
  ,
    code: '<div acCesSKeY="y" />', errors: [expectedError]
  ,
    code: '<div accessKey={"y"} />', errors: [expectedError]
  ,
    code: '<div accessKey={"#{y}"} />', errors: [expectedError]
  ,
    code: '<div accessKey={"#{undefined}y#{undefined}"} />'
    errors: [expectedError]
  ,
    code: '<div accessKey={"This is #{bad}"} />', errors: [expectedError]
  ,
    code: '<div accessKey={accessKey} />', errors: [expectedError]
  ,
    code: '<div accessKey={"#{undefined}"} />', errors: [expectedError]
  ,
    code: '<div accessKey={"#{undefined}#{undefined}"} />'
    errors: [expectedError]
  ].map parserOptionsMapper
