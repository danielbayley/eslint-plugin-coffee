### eslint-env jest ###
###*
# @fileoverview Enforce a clickable non-interactive element has at least 1 keyboard event listener.
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
rule = require 'eslint-plugin-jsx-a11y/lib/rules/click-events-have-key-events'

# -----------------------------------------------------------------------------
# Tests
# -----------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

errorMessage =
  'Visible, non-interactive elements with click handlers must have at least one keyboard listener.'

expectedError =
  message: errorMessage
  type: 'JSXOpeningElement'

ruleTester.run 'click-events-have-key-events', rule,
  valid: [
    code: '<div onClick={() => undefined} onKeyDown={foo}/>'
  ,
    code: '<div onClick={() => undefined} onKeyUp={foo} />'
  ,
    code: '<div onClick={() => undefined} onKeyPress={foo}/>'
  ,
    code: '<div onClick={() => undefined} onKeyDown={foo} onKeyUp={bar} />'
  ,
    code: '<div onClick={() => undefined} onKeyDown={foo} {...props} />'
  ,
    code: '<div className="foo" />'
  ,
    code: '<div onClick={() => undefined} aria-hidden />'
  ,
    code: '<div onClick={() => undefined} aria-hidden={true} />'
  ,
    code:
      '<div onClick={() => undefined} aria-hidden={false} onKeyDown={foo} />'
  ,
    code:
      '<div onClick={() => undefined} onKeyDown={foo} aria-hidden={undefined} />'
  ,
    code: '<input type="text" onClick={() => undefined} />'
  ,
    code: '<input onClick={() => undefined} />'
  ,
    code: '<button onClick={() => undefined} className="foo" />'
  ,
    code: '<option onClick={() => undefined} className="foo" />'
  ,
    code: '<select onClick={() => undefined} className="foo" />'
  ,
    code: '<textarea onClick={() => undefined} className="foo" />'
  ,
    code: '<a onClick={() => undefined} href="http://x.y.z" />'
  ,
    code: '<a onClick={() => undefined} href="http://x.y.z" tabIndex="0" />'
  ,
    code: '<input onClick={() => undefined} type="hidden" />'
  ,
    code: '<div onClick={() => undefined} role="presentation" />'
  ,
    code: '<div onClick={() => undefined} role="none" />'
  ,
    code: '<TestComponent onClick={doFoo} />'
  ,
    code: '<Button onClick={doFoo} />'
  ].map parserOptionsMapper
  invalid: [
    code: '<div onClick={() => undefined} />', errors: [expectedError]
  ,
    code: '<div onClick={() => undefined} role={undefined} />'
    errors: [expectedError]
  ,
    code: '<div onClick={() => undefined} {...props} />'
    errors: [expectedError]
  ,
    code: '<section onClick={() => undefined} />', errors: [expectedError]
  ,
    code: '<main onClick={() => undefined} />', errors: [expectedError]
  ,
    code: '<article onClick={() => undefined} />', errors: [expectedError]
  ,
    code: '<header onClick={() => undefined} />', errors: [expectedError]
  ,
    code: '<footer onClick={() => undefined} />', errors: [expectedError]
  ,
    code: '<div onClick={() => undefined} aria-hidden={false} />'
    errors: [expectedError]
  ,
    code: '<a onClick={() => undefined} />', errors: [expectedError]
  ,
    code: '<a tabIndex="0" onClick={() => undefined} />'
    errors: [expectedError]
  ].map parserOptionsMapper
