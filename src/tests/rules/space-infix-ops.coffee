###*
# @fileoverview Require spaces around infix operators
# @author Michael Ficarra
###

'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------

rule = require '../../rules/space-infix-ops'
{RuleTester} = require 'eslint'
path = require 'path'

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

ruleTester.run 'space-infix-ops', rule,
  valid: [
    'a + b'
    'a     + b'
    '(a) + (b)'
    'a + (b)'
    'a + +(b)'
    'a + (+(b))'
    '(a + b) + (c + d)'
    'a = b'
    'if a then b else c'
    'a if b'
    'a ? b'
    'a and b'
    '''
      a = 1
      a and= b
    '''
    'a %% b'
    'a or b'
    "my_object = {key: 'value'}"
    '{a = 0} = bar'
    '(a = 0) ->'
    'a ** b'
  ,
    code: 'a|0', options: [int32Hint: yes]
  ,
    code: 'a |0', options: [int32Hint: yes]
  ]
  invalid: [
    code: 'a+b'
    output: 'a + b'
    errors: [
      message: 'Infix operators must be spaced.'
      type: 'BinaryExpression'
      line: 1
      column: 2
    ]
  ,
    code: 'a+ b'
    output: 'a + b'
    errors: [
      message: 'Infix operators must be spaced.'
      type: 'BinaryExpression'
      line: 1
      column: 2
    ]
  ,
    code: 'a%%b'
    output: 'a %% b'
    errors: [
      message: 'Infix operators must be spaced.'
      type: 'BinaryExpression'
      line: 1
      column: 2
    ]
  ,
    code: 'a||b'
    output: 'a || b'
    errors: [
      message: 'Infix operators must be spaced.'
      type: 'LogicalExpression'
      line: 1
      column: 2
    ]
  ,
    code: 'a ||b'
    output: 'a || b'
    errors: [
      message: 'Infix operators must be spaced.'
      type: 'LogicalExpression'
      line: 1
      column: 3
    ]
  ,
    code: 'a ?b'
    output: 'a ? b'
    errors: [
      message: 'Infix operators must be spaced.'
      type: 'LogicalExpression'
      line: 1
      column: 3
    ]
  ,
    code: 'a|| b'
    output: 'a || b'
    errors: [
      message: 'Infix operators must be spaced.'
      type: 'LogicalExpression'
      line: 1
      column: 2
    ]
  ,
    code: 'a=b'
    output: 'a = b'
    errors: [
      message: 'Infix operators must be spaced.'
      type: 'AssignmentExpression'
      line: 1
      column: 2
    ]
  ,
    code: 'a= b'
    output: 'a = b'
    errors: [
      message: 'Infix operators must be spaced.'
      type: 'AssignmentExpression'
      line: 1
      column: 2
    ]
  ,
    code: 'a =b'
    output: 'a = b'
    errors: [
      message: 'Infix operators must be spaced.'
      type: 'AssignmentExpression'
      line: 1
      column: 3
    ]
  ,
    code: 'a=b'
    output: 'a = b'
    errors: [
      message: 'Infix operators must be spaced.'
      type: 'AssignmentExpression'
      line: 1
      column: 2
    ]
  ,
    code: 'a= b'
    output: 'a = b'
    errors: [
      message: 'Infix operators must be spaced.'
      type: 'AssignmentExpression'
      line: 1
      column: 2
    ]
  ,
    code: 'a =b'
    output: 'a = b'
    errors: [
      message: 'Infix operators must be spaced.'
      type: 'AssignmentExpression'
      line: 1
      column: 3
    ]
  ,
    code: '''
      a = 1
      a or=b
    '''
    output: '''
      a = 1
      a or= b
    '''
    errors: [
      message: 'Infix operators must be spaced.'
      type: 'AssignmentExpression'
      line: 2
      column: 3
    ]
  ,
    code: '''
      a = 1
      a ?=b
    '''
    output: '''
      a = 1
      a ?= b
    '''
    errors: [
      message: 'Infix operators must be spaced.'
      type: 'AssignmentExpression'
      line: 2
      column: 3
    ]
  ,
    code: 'a = b; c=d'
    output: 'a = b; c = d'
    errors: [
      message: 'Infix operators must be spaced.'
      type: 'AssignmentExpression'
      line: 1
      column: 9
    ]
  ,
    code: 'a| 0'
    output: 'a | 0'
    options: [int32Hint: yes]
    errors: [
      message: 'Infix operators must be spaced.'
      type: 'BinaryExpression'
      line: 1
      column: 2
    ]
  ,
    code: 'output = test || (test && test.value) or(test2 && test2.value)'
    output:
      'output = test || (test && test.value) or (test2 && test2.value)'
    errors: [
      message: 'Infix operators must be spaced.'
      type: 'LogicalExpression'
      line: 1
      column: 39
    ]
  ,
    code: 'output = a or(b && c.value) || (d && e.value)'
    output: 'output = a or (b && c.value) || (d && e.value)'
    errors: [
      message: 'Infix operators must be spaced.'
      type: 'LogicalExpression'
      line: 1
      column: 12
    ]
  ,
    code: 'output = a|| (b and c.value) or (d and e.value)'
    output: 'output = a || (b and c.value) or (d and e.value)'
    errors: [
      message: 'Infix operators must be spaced.'
      type: 'LogicalExpression'
      line: 1
      column: 11
    ]
  ,
    code: "my_object={key: 'value'}"
    output: "my_object = {key: 'value'}"
    errors: [
      message: 'Infix operators must be spaced.'
      type: 'AssignmentExpression'
      line: 1
      column: 10
    ]
  ,
    code: '{a=0}=bar'
    output: '{a = 0} = bar'
    errors: [
      message: 'Infix operators must be spaced.'
      line: 1
      column: 3
      nodeType: 'AssignmentPattern'
    ,
      message: 'Infix operators must be spaced.'
      line: 1
      column: 6
      nodeType: 'VariableDeclarator'
    ]
  ,
    code: '(a=0) ->'
    output: '(a = 0) ->'
    errors: [
      message: 'Infix operators must be spaced.'
      line: 1
      column: 3
      nodeType: 'AssignmentPattern'
    ]
  ,
    code: 'a**b'
    output: 'a ** b'
    errors: [
      message: 'Infix operators must be spaced.'
      line: 1
      column: 2
      nodeType: 'BinaryExpression'
    ]
  ,
    code: "'foo'in{}"
    output: "'foo' in {}"
    errors: [
      message: 'Infix operators must be spaced.'
      line: 1
      column: 6
      nodeType: 'BinaryExpression'
    ]
  ,
    code: "'foo'of{}"
    output: "'foo' of {}"
    errors: [
      message: 'Infix operators must be spaced.'
      line: 1
      column: 6
      nodeType: 'BinaryExpression'
    ]
  ,
    code: "'foo'not in{}"
    output: "'foo' not in {}"
    errors: [
      message: 'Infix operators must be spaced.'
      line: 1
      column: 6
      nodeType: 'BinaryExpression'
    ]
  ,
    code: "'foo'is{}"
    output: "'foo' is {}"
    errors: [
      message: 'Infix operators must be spaced.'
      line: 1
      column: 6
      nodeType: 'BinaryExpression'
    ]
  ,
    code: "'foo'isnt{}"
    output: "'foo' isnt {}"
    errors: [
      message: 'Infix operators must be spaced.'
      line: 1
      column: 6
      nodeType: 'BinaryExpression'
    ]
  ,
    code: "'foo'instanceof{}"
    output: "'foo' instanceof {}"
    errors: [
      message: 'Infix operators must be spaced.'
      line: 1
      column: 6
      nodeType: 'BinaryExpression'
    ]
  ]
