###*
# @fileoverview Tests for no-unneeded-ternary rule.
# @author Gyandeep Singh
###

'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------

rule = require '../../rules/no-unneeded-ternary'
{RuleTester} = require 'eslint'
path = require 'path'

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

ruleTester.run 'no-unneeded-ternary', rule,
  valid: [
    'config.newIsCap = config.newIsCap isnt no'
    "a = if x is 2 then 'Yes' else 'No'"
    "a = if x is 2 then yes else 'No'"
    "a = if x is 2 then 'Yes' else no"
    "a = if x is 2 then 'true' else 'false'"
    'a = if foo then foo else bar'
    '''
      value = 'a'
      canSet = true
      result = value or (if canSet then 'unset' else 'can not set')
    '''
  ,
    code: "a = if foo then 'Yes' else foo"
    options: [defaultAssignment: no]
  ,
    code: 'a = if foo then bar else foo'
    options: [defaultAssignment: no]
  ]
  invalid: [
    code: 'a = if x is 2 then true else false'
    output: 'a = x is 2'
    errors: [
      message: 'Unnecessary use of boolean literals in conditional expression.'
      type: 'ConditionalExpression'
      line: 1
      column: 20
    ]
  ,
    code: 'a = if x is 2 then yes else no'
    output: 'a = x is 2'
    errors: [
      message: 'Unnecessary use of boolean literals in conditional expression.'
      type: 'ConditionalExpression'
      line: 1
      column: 20
    ]
  ,
    code: 'a = if x >= 2 then yes else no'
    output: 'a = x >= 2'
    errors: [
      message: 'Unnecessary use of boolean literals in conditional expression.'
      type: 'ConditionalExpression'
      line: 1
      column: 20
    ]
  ,
    code: 'a = if x then yes else no'
    output: 'a = !!x'
    errors: [
      message: 'Unnecessary use of boolean literals in conditional expression.'
      type: 'ConditionalExpression'
      line: 1
      column: 15
    ]
  ,
    code: 'a = if x is 1 then off else on'
    output: 'a = x isnt 1'
    errors: [
      message: 'Unnecessary use of boolean literals in conditional expression.'
      type: 'ConditionalExpression'
      line: 1
      column: 20
    ]
  ,
    code: '''
      a =
        if x != 1
          no
        else
          yes
    '''
    output: '''
      a =
        x == 1
    '''
    errors: [
      message: 'Unnecessary use of boolean literals in conditional expression.'
      type: 'ConditionalExpression'
      line: 3
      column: 5
    ]
  ,
    code: 'a = if foo() then no else yes'
    output: 'a = !foo()'
    errors: [
      message: 'Unnecessary use of boolean literals in conditional expression.'
      type: 'ConditionalExpression'
      line: 1
      column: 19
    ]
  ,
    code: 'a = if !foo() then false else true'
    output: 'a = !!foo()'
    errors: [
      message: 'Unnecessary use of boolean literals in conditional expression.'
      type: 'ConditionalExpression'
      line: 1
      column: 20
    ]
  ,
    code: 'a = if not foo() then false else true'
    output: 'a = !!foo()'
    errors: [
      message: 'Unnecessary use of boolean literals in conditional expression.'
      type: 'ConditionalExpression'
      line: 1
      column: 23
    ]
  ,
    code: 'a = if foo + bar then no else yes'
    output: 'a = !(foo + bar)'
    errors: [
      message: 'Unnecessary use of boolean literals in conditional expression.'
      type: 'ConditionalExpression'
      line: 1
      column: 23
    ]
  ,
    code: 'a = if x instanceof foo then no else yes'
    output: 'a = !(x instanceof foo)'
    errors: [
      message: 'Unnecessary use of boolean literals in conditional expression.'
      type: 'ConditionalExpression'
      line: 1
      column: 30
    ]
  ,
    code: 'a = if foo then no else no'
    output: 'a = no'
    errors: [
      message: 'Unnecessary use of boolean literals in conditional expression.'
      type: 'ConditionalExpression'
      line: 1
      column: 17
    ]
  ,
    code: 'a = if foo() then no else no'
    output: null
    errors: [
      message: 'Unnecessary use of boolean literals in conditional expression.'
      type: 'ConditionalExpression'
      line: 1
      column: 19
    ]
  ,
    code: 'a = if x instanceof foo then yes else no'
    output: 'a = x instanceof foo'
    errors: [
      message: 'Unnecessary use of boolean literals in conditional expression.'
      type: 'ConditionalExpression'
      line: 1
      column: 30
    ]
  ,
    code: 'a = unless foo then yes else no'
    output: 'a = !foo'
    errors: [
      message: 'Unnecessary use of boolean literals in conditional expression.'
      type: 'ConditionalExpression'
      line: 1
      column: 21
    ]
  ,
    code: '''
      value = 'a'
      canSet = yes
      result = if value then value else if canSet then 'unset' else 'can not set'
    '''
    output: '''
      value = 'a'
      canSet = yes
      result = value or (if canSet then 'unset' else 'can not set')
    '''
    options: [defaultAssignment: no]
    errors: [
      message:
        'Unnecessary use of conditional expression for default assignment.'
      type: 'ConditionalExpression'
      line: 3
      column: 24
    ]
  ,
    code: 'if foo then foo else (if bar then baz else qux)'
    output: 'foo or (if bar then baz else qux)'
    options: [defaultAssignment: no]
    errors: [
      message:
        'Unnecessary use of conditional expression for default assignment.'
      type: 'IfStatement'
      line: 1
      column: 8
    ]
  ,
    code: '-> if foo then foo else yield bar'
    output: '-> foo or (yield bar)'
    options: [defaultAssignment: no]
    errors: [
      message:
        'Unnecessary use of conditional expression for default assignment.'
      type: 'IfStatement'
      line: 1
      column: 11
    ]
  ,
    code: "a = if foo then foo else 'No'"
    output: "a = foo or 'No'"
    options: [defaultAssignment: no]
    errors: [
      message:
        'Unnecessary use of conditional expression for default assignment.'
      type: 'ConditionalExpression'
      line: 1
      column: 17
    ]
  ,
    code:
      'a = if ((foo)) then (((((foo))))) else ((((((((((((((bar))))))))))))))'
    output: 'a = ((foo)) or ((((((((((((((bar))))))))))))))'
    options: [defaultAssignment: no]
    errors: [
      message:
        'Unnecessary use of conditional expression for default assignment.'
      type: 'ConditionalExpression'
      line: 1
      column: 26
    ]
  ]
