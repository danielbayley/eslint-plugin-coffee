###*
# @fileoverview Tests for array-bracket-newline rule.
# @author Jan Peer Stöcklmair <https:#github.com/JPeer264>
###

'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------

rule = require '../../rules/array-bracket-newline'
{RuleTester} = require 'eslint'
path = require 'path'

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

ruleTester.run 'array-bracket-newline', rule,
  valid: [
    ###
    # ArrayExpression
    # "default" { multiline: true }
    ###
    'foo = []'
    'foo = [1]'
    'foo = ### any comment ###[1]'
    '''
      foo = ### any comment ###
        [1]
    '''
    'foo = [1, 2]'
    '''
      foo = [ # any comment
        1, 2
      ]
    '''
    '''
      foo = [
        # any comment
        1, 2
      ]
    '''
    '''
      foo = [
        1, 2
        # any comment
      ]
    '''
    '''
      foo = [
        1,
        2
      ]
    '''
    '''
      foo = [
        ->
          return dosomething()
      ]
    '''
    '''
      foo = [
        if a
          b
        else
          c
      ]
    '''
    '''
      foo = [### 
        any comment
      ###]
    '''
    'foo = [### single line multiline comment for no real reason ###]'
  ,
    # "always"
    code: '''
      foo = [
      ]
    '''
    options: ['always']
  ,
    code: '''
      foo = [
        1
      ]
    '''
    options: ['always']
  ,
    code: '''
      foo = [
        # any
        1
      ]
    '''
    options: ['always']
  ,
    code: '''
      foo = [
        ### any ###
        1
      ]
    '''
    options: ['always']
  ,
    code: '''
      foo = [
        1, 2
      ]
    '''
    options: ['always']
  ,
    code: '''
      foo = [
        1, 2 # any comment
      ]
    '''
    options: ['always']
  ,
    code: '''
      foo = [
        1, 2 ### any comment ###
      ]
    '''
    options: ['always']
  ,
    code: '''
      foo = [
        1,
        2
      ]
    '''
    options: ['always']
  ,
    code: '''
      foo = [
        ->
          dosomething()
      ]
    '''
    options: ['always']
  ,
    code: '''
      foo = [
        if a
          b
      ]
    '''
    options: ['always']
  ,
    # "never"
    code: 'foo = []', options: ['never']
  ,
    code: 'foo = [1]', options: ['never']
  ,
    code: 'foo = [### any comment ###1]', options: ['never']
  ,
    code: 'foo = [1, 2]', options: ['never']
  ,
    code: '''
      foo = [1,
        2]
    '''
    options: ['never']
  ,
    code: '''
      foo = [1,
        ### any comment ###
        2]
    '''
    options: ['never']
  ,
    code: '''
      foo = [->
        dosomething()
      ]
    '''
    options: ['never']
  ,
    code: '''
      foo = [if a
        b
      ]
    '''
    options: ['never']
  ,
    # "consistent"
    code: 'a = []', options: ['consistent']
  ,
    code: '''
      a = [
      ]
    '''
    options: ['consistent']
  ,
    code: 'a = [1]', options: ['consistent']
  ,
    code: '''
      a = [
        1
      ]
    '''
    options: ['consistent']
  ,
    # { multiline: true }
    code: 'foo = []', options: [multiline: yes]
  ,
    code: 'foo = [1]', options: [multiline: yes]
  ,
    code: 'foo = ### any comment ###[1]', options: [multiline: yes]
  ,
    code: '''
      foo = ### any comment ###
        [1]
    '''
    options: [multiline: yes]
  ,
    code: 'foo = [1, 2]', options: [multiline: yes]
  ,
    code: '''
      foo = [ # any comment
        1, 2
      ]
    '''
    options: [multiline: yes]
  ,
    code: '''
      foo = [
        # any comment
        1, 2
      ]
    '''
    options: [multiline: yes]
  ,
    code: '''
      foo = [
        1, 2
        # any comment
      ]
    '''
    options: [multiline: yes]
  ,
    code: '''
      foo = [
        1,
        2
      ]
    '''
    options: [multiline: yes]
  ,
    code: '''
      foo = [
        ->
          return dosomething()
      ]
    '''
    options: [multiline: yes]
  ,
    code: '''
      foo = [
        if a
          b
      ]
    '''
    options: [multiline: yes]
  ,
    code: '''
      foo = [### 
        any comment
        ###]
    '''
    options: [multiline: yes]
  ,
    # { multiline: false }
    code: 'foo = []', options: [multiline: no]
  ,
    code: 'foo = [1]', options: [multiline: no]
  ,
    code: 'foo = [1]### any comment###', options: [multiline: no]
  ,
    code: '''
      foo = [1]
      ### any comment###
    '''
    options: [multiline: no]
  ,
    code: 'foo = [1, 2]', options: [multiline: no]
  ,
    code: '''
      foo = [1,
        2]
    '''
    options: [multiline: no]
  ,
    code: '''
      foo = [->
        return dosomething()
      ]
    '''
    options: [multiline: no]
  ,
    # { minItems: 2 }
    code: 'foo = []', options: [minItems: 2]
  ,
    code: 'foo = [1]', options: [minItems: 2]
  ,
    code: '''
      foo = [
        1, 2
      ]
    '''
    options: [minItems: 2]
  ,
    code: '''
      foo = [
        1,
        2
      ]
    '''
    options: [minItems: 2]
  ,
    code: '''
      foo = [->
        dosomething()
      ]
    '''
    options: [minItems: 2]
  ,
    # { minItems: 0 }
    code: '''
      foo = [
      ]
    '''
    options: [minItems: 0]
  ,
    code: '''
      foo = [
        1
      ]
    '''
    options: [minItems: 0]
  ,
    code: '''
      foo = [
        1, 2
      ]
    '''
    options: [minItems: 0]
  ,
    code: '''
      foo = [
        1,
        2
      ]
    '''
    options: [minItems: 0]
  ,
    code: '''
      foo = [
        ->
          dosomething()
      ]
    '''
    options: [minItems: 0]
  ,
    # { minItems: null }
    code: 'foo = []', options: [minItems: null]
  ,
    code: 'foo = [1]', options: [minItems: null]
  ,
    code: 'foo = [1, 2]', options: [minItems: null]
  ,
    code: '''
      foo = [1,
        2]
    '''
    options: [minItems: null]
  ,
    code: '''
      foo = [->
        dosomething()
      ]
    '''
    options: [minItems: null]
  ,
    # { multiline: true, minItems: null }
    code: 'foo = []', options: [multiline: yes, minItems: null]
  ,
    code: 'foo = [1]', options: [multiline: yes, minItems: null]
  ,
    code: 'foo = [1, 2]', options: [multiline: yes, minItems: null]
  ,
    code: '''
      foo = [
        1,
        2
      ]
    '''
    options: [multiline: yes, minItems: null]
  ,
    code: '''
      foo = [
        ->
          dosomething()
      ]
    '''
    options: [multiline: yes, minItems: null]
  ,
    # { multiline: true, minItems: 2 }
    code: 'a = []', options: [multiline: yes, minItems: 2]
  ,
    code: 'b = [1]', options: [multiline: yes, minItems: 2]
  ,
    code: '''
      b = [ # any comment
        1
      ]
    '''
    options: [multiline: yes, minItems: 2]
  ,
    code: 'b = [ ### any comment ### 1]'
    options: [multiline: yes, minItems: 2]
  ,
    code: '''
      c = [
        1, 2
      ]
    '''
    options: [multiline: yes, minItems: 2]
  ,
    code: '''
      c = [
        ### any comment ###1, 2
      ]
    '''
    options: [multiline: yes, minItems: 2]
  ,
    code: '''
      c = [
        1, ### any comment ### 2
      ]
    '''
    options: [multiline: yes, minItems: 2]
  ,
    code: '''
      d = [
        1
        2
      ]
    '''
    options: [multiline: yes, minItems: 2]
  ,
    code: '''
      e = [
        ->
          dosomething()
      ]
    '''
    options: [multiline: yes, minItems: 2]
  ,
    ###
    # ArrayPattern
    # default { multiline: true }
    ###
    code: '[] = foo'
  ,
    code: '[a] = foo'
  ,
    code: '### any comment ###[a] = foo'
  ,
    code: '''
      ### any comment ###
      [a] = foo
    '''
  ,
    code: '[a, b] = foo'
  ,
    code: '''
      [ # any comment
        a, b
      ] = foo
    '''
  ,
    code: '''
      [
        # any comment
          a, b
      ] = foo
    '''
  ,
    code: '''
      [
        a, b
        # any comment
      ] = foo
    '''
  ,
    code: '''
      [
        a,
        b
      ] = foo
    '''
  ,
    # "always"
    code: '''
      [
      ] = foo
    '''
    options: ['always']
  ,
    code: '''
      [
        a
      ] = foo
    '''
    options: ['always']
  ,
    code: '''
      [
        # any
        a
      ] = foo
    '''
    options: ['always']
  ,
    code: '''
      [
        ### any ###
        a
      ] = foo
    '''
    options: ['always']
  ,
    code: '''
      [
        a, b
      ] = foo
    '''
    options: ['always']
  ,
    code: '''
      [
        a, b # any comment
      ] = foo
    '''
    options: ['always']
  ,
    code: '''
      [
        a, b ### any comment ###
      ] = foo
    '''
    options: ['always']
  ,
    code: '''
      [
        a,
        b
      ] = foo
    '''
    options: ['always']
  ,
    # "consistent"
    code: '[] = foo'
    options: ['consistent']
  ,
    code: '''
      [
      ] = foo
    '''
    options: ['consistent']
  ,
    code: '[a] = foo'
    options: ['consistent']
  ,
    code: '''
      [
        a
      ] = foo
    '''
    options: ['consistent']
  ,
    # { multiline: true }
    code: '[] = foo'
    options: [multiline: yes]
  ,
    code: '[a] = foo'
    options: [multiline: yes]
  ,
    code: '### any comment ###[a] = foo'
    options: [multiline: yes]
  ,
    code: '''
      ### any comment ###
      [a] = foo
    '''
    options: [multiline: yes]
  ,
    code: '[a, b] = foo'
    options: [multiline: yes]
  ,
    code: '''
      [ # any comment
        a, b
      ] = foo
    '''
    options: [multiline: yes]
  ,
    code: '''
      [
        # any comment
        a, b
      ] = foo
    '''
    options: [multiline: yes]
  ,
    code: '''
      [
        a, b
        # any comment
      ] = foo
    '''
    options: [multiline: yes]
  ,
    code: '''
      [
        a,
        b
      ] = foo
    '''
    options: [multiline: yes]
  ,
    '''
      [, a, ,]
    '''
  ]

  invalid: [
    ###
    # ArrayExpression
    # "always"
    ###
    code: 'foo = []'
    # output: 'foo = [\n]'
    options: ['always']
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
      endLine: 1
      endColumn: 8
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 8
      endLine: 1
      endColumn: 9
    ]
  ,
    code: 'foo = [1]'
    # output: 'foo = [\n1\n]'
    options: ['always']
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 9
    ]
  ,
    code: '''
      foo = [ # any comment
        1]
    '''
    # output: 'foo = [ # any comment\n1\n]'
    options: ['always']
    errors: [
      messageId: 'missingClosingLinebreak'
      type: 'ArrayExpression'
      line: 2
      column: 4
      endLine: 2
      endColumn: 5
    ]
  ,
    code: '''
      foo = [ ### any comment ###
        1]
    '''
    # output: 'foo = [ ### any comment ###\n1\n]'
    options: ['always']
    errors: [
      messageId: 'missingClosingLinebreak'
      type: 'ArrayExpression'
      line: 2
      column: 4
    ]
  ,
    code: 'foo = [1, 2]'
    # output: 'foo = [\n1, 2\n]'
    options: ['always']
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
      endLine: 1
      endColumn: 8
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 12
      endLine: 1
      endColumn: 13
    ]
  ,
    code: '''
      foo = [1, 2 # any comment
      ]
    '''
    # output: 'foo = [\n1, 2 # any comment\n]'
    options: ['always']
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ]
  ,
    code: 'foo = [1, 2 ### any comment ###]'
    # output: 'foo = [\n1, 2 ### any comment ###\n]'
    options: ['always']
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 32
    ]
  ,
    code: '''
      foo = [1,
        2]
    '''
    # output: 'foo = [\n1,\n2\n]'
    options: ['always']
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayExpression'
      line: 2
      column: 4
    ]
  ,
    code: '''
      foo = [->
        dosomething()
      ]
    '''
    # output: 'foo = [\nfunction foo() {\ndosomething()\n}\n]'
    options: ['always']
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ]
  ,
    # "never"
    code: '''
      foo = [
      ]
    '''
    # output: 'foo = []'
    options: ['never']
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 2
      column: 1
    ]
  ,
    code: '''
      foo = [
        1
      ]
    '''
    # output: 'foo = [1]'
    options: ['never']
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
      endLine: 1
      endColumn: 8
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 3
      column: 1
      endLine: 3
      endColumn: 2
    ]
  ,
    code: '''
      foo = [
        1
      ]
    '''
    # output: 'foo = [1]'
    options: ['never']
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 3
      column: 1
    ]
  ,
    code: '''
      foo = [ ### any comment ###
        1, 2
      ]
    '''
    # output: 'foo = [ ### any comment ###\n1, 2]'
    options: ['never']
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 3
      column: 1
    ]
  ,
    code: '''
      foo = [
        1, 2
        ### any comment ###
      ]
    '''
    # output: 'foo = [1, 2\n### any comment ###]'
    options: ['never']
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 4
      column: 1
    ]
  ,
    code: '''
      foo = [ # any comment
        1, 2
      ]
    '''
    # output: 'foo = [ # any comment\n1, 2]'
    options: ['never']
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 3
      column: 1
    ]
  ,
    code: '''
      foo = [
        1,
        2
      ]
    '''
    # output: 'foo = [1,\n2]'
    options: ['never']
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 4
      column: 1
    ]
  ,
    code: '''
      foo = [
        ->
          dosomething()
      ]
    '''
    # output: 'foo = [function foo() {\ndosomething()\n}]'
    options: ['never']
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ]
  ,
    code: '''
      foo = [
        if a
          b
      ]
    '''
    # output: 'foo = [function foo() {\ndosomething()\n}]'
    options: ['never']
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ]
  ,
    # "consistent"
    code: '''
      foo = [
        1 ]
    '''
    # output: 'foo = [\n1\n]'
    options: ['consistent']
    errors: [
      messageId: 'missingClosingLinebreak'
      type: 'ArrayExpression'
      line: 2
      column: 5
      endLine: 2
      endColumn: 6
    ]
  ,
    code: '''
      foo = [1
      ]
    '''
    # output: 'foo = [1]'
    options: ['consistent']
    errors: [
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 2
      column: 1
      endLine: 2
      endColumn: 2
    ]
  ,
    # { multiline: true }
    code: '''
      foo = [
      ]
    '''
    # output: 'foo = []'
    options: [multiline: yes]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 2
      column: 1
    ]
  ,
    code: '''
      foo = [
        # any comment
      ]
    '''
    # output: null
    options: [multiline: yes]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 3
      column: 1
    ]
  ,
    code: '''
      foo = [
        1
      ]
    '''
    # output: 'foo = [1]'
    options: [multiline: yes]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 3
      column: 1
    ]
  ,
    code: '''
      foo = [
        1, 2
      ]
    '''
    # output: 'foo = [1, 2]'
    options: [multiline: yes]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 3
      column: 1
    ]
  ,
    code: '''
      foo = [1,
        2]
    '''
    # output: 'foo = [\n1,\n2\n]'
    options: [multiline: yes]
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayExpression'
      line: 2
      column: 4
    ]
  ,
    code: '''
      foo = [->
        dosomething()
      ]
    '''
    # output: 'foo = [\nfunction foo() {\ndosomething()\n}\n]'
    options: [multiline: yes]
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ]
  ,
    code: '''
      foo = [if a
        b
      ]
    '''
    # output: 'foo = [\nfunction foo() {\ndosomething()\n}\n]'
    options: [multiline: yes]
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ]
  ,
    # { minItems: 2 }
    code: '''
      foo = [
      ]
    '''
    # output: 'foo = []'
    options: [minItems: 2]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 2
      column: 1
    ]
  ,
    code: '''
      foo = [
        1
      ]
    '''
    # output: 'foo = [1]'
    options: [minItems: 2]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 3
      column: 1
    ]
  ,
    code: 'foo = [1, 2]'
    # output: 'foo = [\n1, 2\n]'
    options: [minItems: 2]
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 12
    ]
  ,
    code: '''
      foo = [1,
        2]
    '''
    # output: 'foo = [\n1,\n2\n]'
    options: [minItems: 2]
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayExpression'
      line: 2
      column: 4
    ]
  ,
    code: '''
      foo = [
        ->
          dosomething()
      ]
    '''
    # output: 'foo = [function foo() {\ndosomething()\n}]'
    options: [minItems: 2]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ]
  ,
    # { minItems: 0 }
    code: 'foo = []'
    # output: 'foo = [\n]'
    options: [minItems: 0]
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 8
    ]
  ,
    code: 'foo = [1]'
    # output: 'foo = [\n1\n]'
    options: [minItems: 0]
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 9
    ]
  ,
    code: 'foo = [1, 2]'
    # output: 'foo = [\n1, 2\n]'
    options: [minItems: 0]
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 12
    ]
  ,
    code: '''
      foo = [1,
        2]
    '''
    # output: 'foo = [\n1,\n2\n]'
    options: [minItems: 0]
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayExpression'
      line: 2
      column: 4
    ]
  ,
    code: '''
      foo = [->
        dosomething()
      ]
    '''
    # output: 'foo = [\nfunction foo() {\ndosomething()\n}\n]'
    options: [minItems: 0]
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ]
  ,
    # { minItems: null }
    code: '''
      foo = [
      ]
    '''
    # output: 'foo = []'
    options: [minItems: null]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 2
      column: 1
    ]
  ,
    code: '''
      foo = [
        1
      ]
    '''
    # output: 'foo = [1]'
    options: [minItems: null]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 3
      column: 1
    ]
  ,
    code: '''
      foo = [
        1, 2
      ]
    '''
    # output: 'foo = [1, 2]'
    options: [minItems: null]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 3
      column: 1
    ]
  ,
    code: '''
      foo = [
        1
        2
      ]
    '''
    # output: 'foo = [1,\n2]'
    options: [minItems: null]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 4
      column: 1
    ]
  ,
    code: '''
      foo = [
        ->
          dosomething()
      ]
    '''
    # output: 'foo = [function foo() {\ndosomething()\n}]'
    options: [minItems: null]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ]
  ,
    # { multiline: true, minItems: null }
    code: '''
      foo = [
      ]
    '''
    # output: 'foo = []'
    options: [multiline: yes, minItems: null]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 2
      column: 1
    ]
  ,
    code: '''
      foo = [
        1
      ]
    '''
    # output: 'foo = [1]'
    options: [multiline: yes, minItems: null]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 3
      column: 1
    ]
  ,
    code: '''
      foo = [
        1, 2
      ]
    '''
    # output: 'foo = [1, 2]'
    options: [multiline: yes, minItems: null]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 3
      column: 1
    ]
  ,
    code: '''
      foo = [1,
      2]
    '''
    # output: 'foo = [\n1,\n2\n]'
    options: [multiline: yes, minItems: null]
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayExpression'
      line: 2
      column: 2
    ]
  ,
    code: '''
      foo = [->
        dosomething()
      ]
    '''
    # output: 'foo = [\nfunction foo() {\ndosomething()\n}\n]'
    options: [multiline: yes, minItems: null]
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ]
  ,
    # { multiline: true, minItems: 2 }
    code: '''
      foo = [
      ]
    '''
    # output: 'foo = []'
    options: [multiline: yes, minItems: 2]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 2
      column: 1
    ]
  ,
    code: '''
      foo = [
        1
      ]
    '''
    # output: 'foo = [1]'
    options: [multiline: yes, minItems: 2]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 3
      column: 1
    ]
  ,
    code: 'foo = [1, 2]'
    # output: 'foo = [\n1, 2\n]'
    options: [multiline: yes, minItems: 2]
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 12
    ]
  ,
    code: '''
      foo = [1,
        2]
    '''
    # output: 'foo = [\n1,\n2\n]'
    options: [multiline: yes, minItems: 2]
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayExpression'
      line: 2
      column: 4
    ]
  ,
    code: '''
      foo = [->
        dosomething()
      ]
    '''
    # output: 'foo = [\nfunction foo() {\ndosomething()\n}\n]'
    options: [multiline: yes, minItems: 2]
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ]
  ,
    ###
    # extra test cases
    # "always"
    ###
    code: '''
      foo = [
        1, 2]
    '''
    # output: 'foo = [\n1, 2\n]'
    options: ['always']
    errors: [
      messageId: 'missingClosingLinebreak'
      type: 'ArrayExpression'
      line: 2
      column: 7
    ]
  ,
    code: 'foo = [\t1, 2]'
    # output: 'foo = [\n\t1, 2\n]'
    options: ['always']
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 13
    ]
  ,
    code: '''
      foo = [1,
        2
      ]
    '''
    # output: 'foo = [\n1,\n2\n]'
    options: ['always']
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ]
  ,
    #  { multiline: false }
    code: '''
      foo = [
      ]
    '''
    # output: 'foo = []'
    options: [multiline: no]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 2
      column: 1
    ]
  ,
    code: '''
      foo = [
        1
      ]
    '''
    # output: 'foo = [1]'
    options: [multiline: no]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 3
      column: 1
    ]
  ,
    code: '''
      foo = [
        1, 2
      ]
    '''
    # output: 'foo = [1, 2]'
    options: [multiline: no]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 3
      column: 1
    ]
  ,
    code: '''
      foo = [
        1
        2
      ]
    '''
    # output: 'foo = [1,\n2]'
    options: [multiline: no]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayExpression'
      line: 4
      column: 1
    ]
  ,
    code: '''
      foo = [
        ->
          dosomething()
      ]
    '''
    # output: 'foo = [function foo() {\ndosomething()\n}]'
    options: [multiline: no]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayExpression'
      line: 1
      column: 7
    ]
  ,
    ###
    # ArrayPattern
    # "always"
    ###
    code: '[] = foo'
    # output: '[\n] = foo'
    options: ['always']
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayPattern'
      line: 1
      column: 1
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayPattern'
      line: 1
      column: 2
    ]
  ,
    code: '[a] = foo'
    # output: '[\na\n] = foo'
    options: ['always']
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayPattern'
      line: 1
      column: 1
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayPattern'
      line: 1
      column: 3
    ]
  ,
    code: '''
      [ # any comment
        a] = foo
    '''
    # output: '[ # any comment\na\n] = foo'
    options: ['always']
    errors: [
      messageId: 'missingClosingLinebreak'
      type: 'ArrayPattern'
      line: 2
      column: 4
    ]
  ,
    code: '''
      [ ### any comment ###
        a] = foo
    '''
    # output: '[ ### any comment ###\na\n] = foo'
    options: ['always']
    errors: [
      messageId: 'missingClosingLinebreak'
      type: 'ArrayPattern'
      line: 2
      column: 4
    ]
  ,
    code: '[a, b] = foo'
    # output: '[\na, b\n] = foo'
    options: ['always']
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayPattern'
      line: 1
      column: 1
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayPattern'
      line: 1
      column: 6
    ]
  ,
    code: '''
      [a, b # any comment
      ] = foo
    '''
    # output: '[\na, b # any comment\n] = foo'
    options: ['always']
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayPattern'
      line: 1
      column: 1
    ]
  ,
    code: '[a, b ### any comment ###] = foo'
    # output: '[\na, b ### any comment ###\n] = foo'
    options: ['always']
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayPattern'
      line: 1
      column: 1
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayPattern'
      line: 1
      column: 26
    ]
  ,
    code: '''
      [a,
        b] = foo
    '''
    # output: '[\na,\nb\n] = foo'
    options: ['always']
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayPattern'
      line: 1
      column: 1
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayPattern'
      line: 2
      column: 4
    ]
  ,
    # "consistent"
    code: '''
      [
        a] = foo
    '''
    # output: '[\na\n] = foo'
    options: ['consistent']
    errors: [
      messageId: 'missingClosingLinebreak'
      type: 'ArrayPattern'
      line: 2
      column: 4
      endLine: 2
      endColumn: 5
    ]
  ,
    code: '''
      [a
      ] = foo
    '''
    # output: '[a] = foo'
    options: ['consistent']
    errors: [
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayPattern'
      line: 2
      column: 1
      endLine: 2
      endColumn: 2
    ]
  ,
    # { minItems: 2 }
    code: '''
      [
      ] = foo
    '''
    # output: '[] = foo'
    options: [minItems: 2]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayPattern'
      line: 1
      column: 1
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayPattern'
      line: 2
      column: 1
    ]
  ,
    code: '''
      [
        a
      ] = foo
    '''
    # output: '[a] = foo'
    options: [minItems: 2]
    errors: [
      messageId: 'unexpectedOpeningLinebreak'
      type: 'ArrayPattern'
      line: 1
      column: 1
    ,
      messageId: 'unexpectedClosingLinebreak'
      type: 'ArrayPattern'
      line: 3
      column: 1
    ]
  ,
    code: '[a, b] = foo'
    # output: '[\na, b\n] = foo'
    options: [minItems: 2]
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayPattern'
      line: 1
      column: 1
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayPattern'
      line: 1
      column: 6
    ]
  ,
    code: '''
      [a,
        b] = foo
    '''
    # output: '[\na,\nb\n] = foo'
    options: [minItems: 2]
    errors: [
      messageId: 'missingOpeningLinebreak'
      type: 'ArrayPattern'
      line: 1
      column: 1
    ,
      messageId: 'missingClosingLinebreak'
      type: 'ArrayPattern'
      line: 2
      column: 4
    ]
  ]
