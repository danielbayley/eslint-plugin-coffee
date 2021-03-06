###*
# @fileoverview Tests for no-script-url rule.
# @author Ilya Volodin
###

'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------

rule = require 'eslint/lib/rules/no-script-url'
{RuleTester} = require 'eslint'
path = require 'path'

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

ruleTester.run 'no-script-url', rule,
  valid: ["a = 'Hello World!'", 'a = 10', "url = 'xjavascript:'"]
  invalid: [
    code: "a = 'javascript:void(0)'"
    errors: [message: 'Script URL is a form of eval.', type: 'Literal']
  ,
    code: "a = 'javascript:'"
    errors: [message: 'Script URL is a form of eval.', type: 'Literal']
  ]
