###*
# @fileoverview Tests for no-multi-str rule.
# @author Ilya Volodin
###

'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------

rule = require 'eslint/lib/rules/no-multi-str'
{RuleTester} = require 'eslint'
path = require 'path'

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

ruleTester.run 'no-multi-str', rule,
  valid: ["a = 'Line 1 Line 2'", 'a = <div>\n<h1>Wat</h1>\n</div>']
  invalid: [
    code: "x = 'Line 1 \\\n Line 2'"
    errors: [
      message: 'Multiline support is limited to browsers supporting ES5 only.'
      type: 'Literal'
    ]
  ,
    code: "test('Line 1 \\\n Line 2')"
    errors: [
      message: 'Multiline support is limited to browsers supporting ES5 only.'
      type: 'Literal'
    ]
  ,
    # TODO: looks like Coffeescript strips all carriage returns before lexing?
    # ,
    #   code: "'foo\\\rbar'"
    #   errors: [
    #     message: 'Multiline support is limited to browsers supporting ES5 only.'
    #     type: 'Literal'
    #   ]
    code: "'foo\\\u2028bar'"
    errors: [
      message: 'Multiline support is limited to browsers supporting ES5 only.'
      type: 'Literal'
    ]
  ,
    code: "'foo\\\u2029ar'"
    errors: [
      message: 'Multiline support is limited to browsers supporting ES5 only.'
      type: 'Literal'
    ]
  ]
