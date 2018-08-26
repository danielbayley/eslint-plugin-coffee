###*
# @fileoverview Tests for no-iterator rule.
# @author Ian Christian Myers
###

'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------

rule = require 'eslint/lib/rules/no-iterator'
{RuleTester} = require 'eslint'

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------

ruleTester = new RuleTester parser: '../../..'

ruleTester.run 'no-iterator', rule,
  valid: ['a = test[__iterator__]', '__iterator__ = null']
  invalid: [
    code: 'a = test.__iterator__'
    errors: [
      message: "Reserved name '__iterator__'.", type: 'MemberExpression'
    ]
  ,
    code: 'Foo.prototype.__iterator__ = ->'
    errors: [
      message: "Reserved name '__iterator__'.", type: 'MemberExpression'
    ]
  ,
    code: 'Foo::__iterator__ = ->'
    errors: [
      message: "Reserved name '__iterator__'.", type: 'MemberExpression'
    ]
  ,
    code: "a = test['__iterator__']"
    errors: [
      message: "Reserved name '__iterator__'.", type: 'MemberExpression'
    ]
  ]