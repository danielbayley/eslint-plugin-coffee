###*
# @fileoverview Tests for template-curly-spacing rule.
# @author Toru Nagashima
###

'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------

rule = require '../../rules/template-curly-spacing'
{RuleTester} = require 'eslint'
path = require 'path'

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

### eslint-disable coffee/no-template-curly-in-string ###
ruleTester.run 'template-curly-spacing', rule,
  valid: [
    '{ foo }'
    '"#{foo} #{bar}"'
  ,
    code: '"#{foo} #{bar} #{\n  baz\n}"', options: ['never']
  ,
    code: '"#{ foo } #{ bar } #{\n  baz\n}"', options: ['always']
  ,
    'tag"#{foo} #{bar}"'
  ,
    code: 'tag"#{foo} #{bar} #{\n  baz\n}"', options: ['never']
  ,
    code: 'tag"#{ foo } #{ bar } #{\n  baz\n}"', options: ['always']
  ,
    '"#{}"'
  ]
  invalid: [
    code: '"#{ foo } #{ bar }"'
    output: '"#{foo} #{bar}"'
    errors: [
      message: 'Unexpected space(s) after \'#{\'.', column: 2
    ,
      message: "Unexpected space(s) before '}'.", column: 9
    ,
      message: 'Unexpected space(s) after \'#{\'.', column: 11
    ,
      message: "Unexpected space(s) before '}'.", column: 18
    ]
  ,
    code: '"#{ foo } #{ bar }"'
    output: '"#{foo} #{bar}"'
    options: ['never']
    errors: [
      message: 'Unexpected space(s) after \'#{\'.', column: 2
    ,
      message: "Unexpected space(s) before '}'.", column: 9
    ,
      message: 'Unexpected space(s) after \'#{\'.', column: 11
    ,
      message: "Unexpected space(s) before '}'.", column: 18
    ]
  ,
    code: '"#{foo} #{bar}"'
    output: '"#{ foo } #{ bar }"'
    options: ['always']
    errors: [
      message: 'Expected space(s) after \'#{\'.', column: 2
    ,
      message: "Expected space(s) before '}'.", column: 7
    ,
      message: 'Expected space(s) after \'#{\'.', column: 9
    ,
      message: "Expected space(s) before '}'.", column: 14
    ]
  ,
    code: 'tag"#{ foo } #{ bar }"'
    output: 'tag"#{foo} #{bar}"'
    errors: [
      message: 'Unexpected space(s) after \'#{\'.', column: 5
    ,
      message: "Unexpected space(s) before '}'.", column: 12
    ,
      message: 'Unexpected space(s) after \'#{\'.', column: 14
    ,
      message: "Unexpected space(s) before '}'.", column: 21
    ]
  ,
    code: 'tag"#{ foo } #{ bar }"'
    output: 'tag"#{foo} #{bar}"'
    options: ['never']
    errors: [
      message: 'Unexpected space(s) after \'#{\'.', column: 5
    ,
      message: "Unexpected space(s) before '}'.", column: 12
    ,
      message: 'Unexpected space(s) after \'#{\'.', column: 14
    ,
      message: "Unexpected space(s) before '}'.", column: 21
    ]
  ,
    code: 'tag"#{foo} #{bar}"'
    output: 'tag"#{ foo } #{ bar }"'
    options: ['always']
    errors: [
      message: 'Expected space(s) after \'#{\'.', column: 5
    ,
      message: "Expected space(s) before '}'.", column: 10
    ,
      message: 'Expected space(s) after \'#{\'.', column: 12
    ,
      message: "Expected space(s) before '}'.", column: 17
    ]
  ]
