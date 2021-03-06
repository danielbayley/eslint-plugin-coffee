### eslint-env jest ###
###*
# @fileoverview Enforce explicit role property is not the
# same as implicit default role property on element.
# @author Ethan Cohen <@evcohen>
###

# -----------------------------------------------------------------------------
# Requirements
# -----------------------------------------------------------------------------

path = require 'path'
{RuleTester} = require 'eslint'
{
  default: parserOptionsMapper
} = require '../eslint-plugin-jsx-a11y-parser-options-mapper'
rule = require 'eslint-plugin-jsx-a11y/lib/rules/no-redundant-roles'
{
  default: ruleOptionsMapperFactory
} = require '../eslint-plugin-jsx-a11y-rule-options-mapper-factory'

# -----------------------------------------------------------------------------
# Tests
# -----------------------------------------------------------------------------

### eslint-disable coffee/no-template-curly-in-string ###

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

expectedError = (element, implicitRole) ->
  message: "The element #{element} has an implicit role of #{implicitRole}. Defining this explicitly is redundant and should be avoided."
  type: 'JSXOpeningElement'

ruleName = 'jsx-a11y/no-redundant-roles'

alwaysValid = [
  code: '<div />'
,
  code: '<button role="main" />'
,
  code: '<MyComponent role="button" />'
,
  code: '<button role={"#{foo}button"} />'
]

neverValid = [
  code: '<button role="button" />', errors: [expectedError 'button', 'button']
,
  code: '<body role="DOCUMENT" />', errors: [expectedError 'body', 'document']
]

ruleTester.run "#{ruleName}:recommended", rule,
  valid: [...alwaysValid, {code: '<nav role="navigation" />'}].map(
    parserOptionsMapper
  )
  invalid: neverValid.map parserOptionsMapper

noNavExceptionsOptions = nav: []

ruleTester.run "#{ruleName}:recommended", rule,
  valid:
    alwaysValid
    .map(ruleOptionsMapperFactory noNavExceptionsOptions)
    .map(parserOptionsMapper)
  invalid:
    [
      ...neverValid
    ,
      code: '<nav role="navigation" />'
      errors: [expectedError 'nav', 'navigation']
    ]
    .map ruleOptionsMapperFactory noNavExceptionsOptions
    .map parserOptionsMapper
