###*
# @fileoverview Tests for dot-location.
# @author Greg Cochard
###

'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------

rule = require '../../rules/dot-location'
{RuleTester} = require 'eslint'
path = require 'path'

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

ruleTester.run 'dot-location', rule,
  valid: [
    'obj.\nprop'
    'obj. \nprop'
    'obj.\n prop'
    '(obj).\nprop'
    "obj['prop']"
  ,
    code: 'obj.\nprop'
    options: ['object']
  ,
    code: 'obj\n.prop'
    options: ['property']
  ,
    code: '(obj)\n.prop'
    options: ['property']
  ,
    '''
      String::dasherize = ->
        this.replace /_/g, "-"
    '''
    '@b'
  ]
  invalid: [
    code: 'obj\n.property'
    output: 'obj.\nproperty'
    options: ['object']
    errors: [
      messageId: 'expectedDotAfterObject'
      type: 'MemberExpression'
      line: 2
      column: 1
    ]
  ,
    code: 'this\n.property'
    output: 'this.\nproperty'
    options: ['object']
    errors: [
      messageId: 'expectedDotAfterObject'
      type: 'MemberExpression'
      line: 2
      column: 1
    ]
  ,
    code: 'obj.\nproperty'
    output: 'obj\n.property'
    options: ['property']
    errors: [
      messageId: 'expectedDotBeforeProperty'
      type: 'MemberExpression'
      line: 1
      column: 4
    ]
  ,
    code: '(obj).\nproperty'
    output: '(obj)\n.property'
    options: ['property']
    errors: [
      messageId: 'expectedDotBeforeProperty'
      type: 'MemberExpression'
      line: 1
      column: 6
    ]
  ,
    code: '5\n.toExponential()'
    output: '5 .\ntoExponential()'
    options: ['object']
    errors: [
      messageId: 'expectedDotAfterObject'
      type: 'MemberExpression'
      line: 2
      column: 1
    ]
  ,
    code: '-5\n.toExponential()'
    output: '-5 .\ntoExponential()'
    options: ['object']
    errors: [
      messageId: 'expectedDotAfterObject'
      type: 'MemberExpression'
      line: 2
      column: 1
    ]
  ,
    code: 'foo ### a ### . ### b ### \n ### c ### bar'
    output: 'foo ### a ###  ### b ### \n ### c ### .bar'
    options: ['property']
    errors: [
      messageId: 'expectedDotBeforeProperty'
      type: 'MemberExpression'
      line: 1
      column: 15
    ]
  ,
    code: 'foo ### a ### \n ### b ### . ### c ### bar'
    output: 'foo. ### a ### \n ### b ###  ### c ### bar'
    options: ['object']
    errors: [
      messageId: 'expectedDotAfterObject'
      type: 'MemberExpression'
      line: 2
      column: 12
    ]
  ]
