### eslint-env jest ###
###*
# @fileoverview Enforce aria role attribute is valid.
# @author Ethan Cohen
###

# -----------------------------------------------------------------------------
# Requirements
# -----------------------------------------------------------------------------

path = require 'path'
{roles} = require 'aria-query'
{RuleTester} = require 'eslint'
{
  default: parserOptionsMapper
} = require '../eslint-plugin-jsx-a11y-parser-options-mapper'
rule = require 'eslint-plugin-jsx-a11y/lib/rules/aria-role'

# -----------------------------------------------------------------------------
# Tests
# -----------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

errorMessage =
  message: 'Elements with ARIA roles must use a valid, non-abstract ARIA role.'
  type: 'JSXAttribute'

roleKeys = [...roles.keys()]

validRoles = roleKeys.filter (role) -> roles.get(role).abstract is no
invalidRoles = roleKeys.filter (role) -> roles.get(role).abstract is yes

createTests = (roleNames) ->
  roleNames.map (role) ->
    code: "<div role=\"#{role.toLowerCase()}\" />"

validTests = createTests validRoles
invalidTests = createTests(invalidRoles).map (test) ->
  invalidTest = {...test}
  invalidTest.errors = [errorMessage]
  invalidTest

ignoreNonDOMSchema = [ignoreNonDOM: yes]

ruleTester.run 'aria-role', rule,
  valid:
    [
      # Variables should pass, as we are only testing literals.
      code: '<div />'
    ,
      code: '<div></div>'
    ,
      code: '<div role={role} />'
    ,
      code: '<div role={role || "button"} />'
    ,
      code: '<div role={role || "foobar"} />'
    ,
      code: '<div role="tabpanel row" />'
    ,
      code: '<div role="switch" />'
    ,
      code: '<div role="doc-abstract" />'
    ,
      code: '<div role="doc-appendix doc-bibliography" />'
    ,
      code: '<Bar baz />'
    ,
      code: '<Foo role="bar" />', options: ignoreNonDOMSchema
    ,
      code: '<fakeDOM role="bar" />', options: ignoreNonDOMSchema
    ,
      code: '<img role="presentation" />', options: ignoreNonDOMSchema
    ]
    .concat validTests
    .map parserOptionsMapper
  invalid:
    [
      code: '<div role="foobar" />', errors: [errorMessage]
    ,
      code: '<div role="datepicker"></div>', errors: [errorMessage]
    ,
      code: '<div role="range"></div>', errors: [errorMessage]
    ,
      code: '<div role="Button"></div>', errors: [errorMessage]
    ,
      code: '<div role=""></div>', errors: [errorMessage]
    ,
      code: '<div role="tabpanel row foobar"></div>', errors: [errorMessage]
    ,
      code: '<div role="tabpanel row range"></div>', errors: [errorMessage]
    ,
      code: '<div role="doc-endnotes range"></div>', errors: [errorMessage]
    ,
      code: '<div role />', errors: [errorMessage]
    ,
      code: '<div role={null}></div>', errors: [errorMessage]
    ,
      code: '<Foo role="datepicker" />', errors: [errorMessage]
    ,
      code: '<Foo role="Button" />', errors: [errorMessage]
    ]
    .concat invalidTests
    .map parserOptionsMapper
