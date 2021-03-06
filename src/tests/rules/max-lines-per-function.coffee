###*
# @fileoverview Tests for max-lines-per-function rule.
# @author Pete Ward <peteward44@gmail.com>
###
'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------
rule = require '../../rules/max-lines-per-function'
{RuleTester} = require 'eslint'
path = require 'path'

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

ruleTester.run 'max-lines-per-function', rule,
  valid: [
    # Test code in global scope doesn't count
    code: '''
      x = 5
      x = 2
    '''
    options: [1]
  ,
    # Test single line standlone function
    code: 'name = ->'
    options: [1]
  ,
    # Test standalone function with lines of code
    code: '''
      ->
        x = 5
        x = 2
    '''
    options: [3]
  ,
    # skipBlankLines: false with simple standalone function
    code: '''
      ->
        x = 5



        x = 2
    '''
    options: [max: 6, skipComments: no, skipBlankLines: no]
  ,
    # skipBlankLines: true with simple standalone function
    code: '''
      ->
        x = 5
        
        
        
        x = 2
    '''
    options: [max: 4, skipComments: no, skipBlankLines: yes]
  ,
    # skipComments: true with an individual single line comment
    code: '''
      ->
        x = 5
        x = 2 # end of line comment
    '''
    options: [max: 3, skipComments: yes, skipBlankLines: no]
  ,
    # skipComments: true with an individual single line comment
    code: '''
      ->
        x = 5
        # a comment on it's own line
        x = 2
        # end of line comment
    '''
    options: [max: 4, skipComments: yes, skipBlankLines: no]
  ,
    # skipComments: true with single line comments
    code: '''
      ->
        x = 5
        # a comment on it's own line
        # and another line comment
        x = 2 # end of line comment
    '''
    options: [max: 4, skipComments: yes, skipBlankLines: no]
  ,
    # skipComments: true test with multiple different comment types
    code: '''
      ->
        x = 5
        ### a 
          multi 
          line 
          comment 
        ###

        x = 2 # end of line comment
    '''
    options: [max: 5, skipComments: yes, skipBlankLines: no]
  ,
    # skipComments: true with multiple different comment types, including trailing and leading whitespace
    code: '''
      ->
        x = 5
        ### a comment with leading whitespace ###
        ### a comment with trailing whitespace ### 
        ### a comment with trailing and leading whitespace ### 
        ### a 
          multi 
          line 
          comment 
        ###

        x = 2 # end of line comment
    '''
    options: [max: 5, skipComments: yes, skipBlankLines: no]
  ,
    # Multiple params on seperate lines test
    code: '''
      (
        aaa = 1,
        bbb = 2,
        ccc = 3
      ) ->
        return aaa + bbb + ccc
    '''
    options: [max: 7, skipComments: yes, skipBlankLines: no]
  ,
    # IIFE validity test
    code: '''
      (
        ->
          a
          b
          c
      )()
    '''
    options: [max: 4, skipComments: yes, skipBlankLines: no, IIFEs: yes]
  ,
    code: '''
      do (
        ->
          a
          b
          c
      )
    '''
    options: [max: 4, skipComments: yes, skipBlankLines: no, IIFEs: yes]
  ,
    # Nested function validity test
    code: '''
      ->
        x = 0
        nested = ->
          y = 0
          x = 2
          if x is y
            x++
    '''
    options: [max: 7, skipComments: yes, skipBlankLines: no]
  ,
    # Class method validity test
    code: '''
      class foo
        method: ->
          y = 10
          x = 20
          y + x
    '''
    options: [max: 4, skipComments: yes, skipBlankLines: no]
  ,
    # IIFEs should be recognised if IIFEs: true
    code: '''
      do ->
        x = 0
        y = 0
        z = x + y
        foo = {}
        bar
    '''
    options: [max: 6, skipComments: yes, skipBlankLines: no, IIFEs: yes]
  ,
    # IIFEs should not be recognised if IIFEs: false
    code: '''
      do ->
        x = 0
        y = 0
        z = x + y
        foo = {}
        bar
    '''
    options: [max: 2, skipComments: yes, skipBlankLines: no, IIFEs: no]
  ]

  invalid: [
    # Test simple standalone function is recognised
    code: '''
      ->
        a
    '''
    options: [1]
    errors: ['function has too many lines (2). Maximum allowed is 1.']
  ,
    # Test anonymous function assigned to variable is recognised
    code: '''
      func = ->
        a
    '''
    options: [1]
    errors: ["function 'func' has too many lines (2). Maximum allowed is 1."]
  ,
    # Test arrow functions are recognised
    code: '''
      bar = () =>
        x = 2 + 1
        return x
    '''
    options: [2]
    errors: ['arrow function has too many lines (3). Maximum allowed is 2.']
  ,
    # Test skipBlankLines: false
    code: '''
      ->
        x = 5


        

        x = 2
    '''
    options: [max: 6, skipComments: no, skipBlankLines: no]
    errors: ['function has too many lines (7). Maximum allowed is 6.']
  ,
    # Test skipBlankLines: false with CRLF line endings
    code: '->\r\n  x = 5\r\n\t\r\n \r\n\r\n\r\n  x = 2\r\n'
    options: [max: 6, skipComments: yes, skipBlankLines: no]
    errors: ['function has too many lines (7). Maximum allowed is 6.']
  ,
    # Test skipBlankLines: true
    code: '''
      name = ->
        x = 5
        
        
        
        x = 2
    '''
    options: [max: 2, skipComments: yes, skipBlankLines: yes]
    errors: ["function 'name' has too many lines (3). Maximum allowed is 2."]
  ,
    # Test skipBlankLines: true with CRLF line endings
    code: '->\r\n  x = 5\r\n\t\r\n \r\n\r\n  x = 2\r\n'
    options: [max: 2, skipComments: yes, skipBlankLines: yes]
    errors: ['function has too many lines (3). Maximum allowed is 2.']
  ,
    # Test skipComments: true and skipBlankLines: false for multiple types of comment
    code: '''
      name = -> # end of line comment
        x = 5 ### mid line comment ###
        # single line comment taking up whole line




        x = 2
    '''
    options: [max: 6, skipComments: yes, skipBlankLines: no]
    errors: ["function 'name' has too many lines (7). Maximum allowed is 6."]
  ,
    # Test skipComments: true and skipBlankLines: true for multiple types of comment
    code: '''
      name = -> # end of line comment
        x = 5 ### mid line comment ###
        # single line comment taking up whole line

        
        
        x = 2
    '''
    options: [max: 1, skipComments: yes, skipBlankLines: yes]
    errors: ["function 'name' has too many lines (3). Maximum allowed is 1."]
  ,
    # Test skipComments: false and skipBlankLines: true for multiple types of comment
    code: '''
      name = -> # end of line comment
        x = 5 ### mid line comment ###
        # single line comment taking up whole line

        
        
        x = 2
    '''
    options: [max: 1, skipComments: no, skipBlankLines: yes]
    errors: ["function 'name' has too many lines (4). Maximum allowed is 1."]
  ,
    # Test simple standalone function with params on separate lines
    code: '''
      foo = (
        aaa = 1,
        bbb = 2,
        ccc = 3
      ) ->
        return aaa + bbb + ccc
    '''
    options: [max: 2, skipComments: yes, skipBlankLines: no]
    errors: ["function 'foo' has too many lines (6). Maximum allowed is 2."]
  ,
    # Test IIFE "function" keyword is included in the count
    code: '''
      (
        ->
          a

          b
      )()
    '''
    options: [max: 2, skipComments: yes, skipBlankLines: no, IIFEs: yes]
    errors: ['function has too many lines (4). Maximum allowed is 2.']
  ,
    code: '''
      do ->
        a

        b
    '''
    options: [max: 2, skipComments: yes, skipBlankLines: no, IIFEs: yes]
    errors: ['function has too many lines (4). Maximum allowed is 2.']
  ,
    # Test nested functions are included in it's parent's function count.
    code: '''
      parent = ->
        x = 0

        nested = ->
          y = 0

          x = 2

        if x is y
          x++
    '''
    options: [max: 9, skipComments: yes, skipBlankLines: no]
    errors: ["function 'parent' has too many lines (10). Maximum allowed is 9."]
  ,
    # Test nested functions are included in it's parent's function count.
    code: '''
      parent = ->
        x = 0
        nested = ->
          y = 0
          x = 2
        if x is y
          x++
    '''
    options: [max: 2, skipComments: yes, skipBlankLines: no]
    errors: [
      "function 'parent' has too many lines (7). Maximum allowed is 2."
      "function 'nested' has too many lines (3). Maximum allowed is 2."
    ]
  ,
    # Test regular methods are recognised
    code: '''
      class foo
        method: ->
          y = 10
          x = 20
          y + x
    '''
    options: [max: 2, skipComments: yes, skipBlankLines: no]
    errors: ["method 'method' has too many lines (4). Maximum allowed is 2."]
  ,
    # Test static methods are recognised
    code: '''
      class A
        @foo: (a) ->

          a
    '''
    options: [max: 2, skipComments: yes, skipBlankLines: no]
    errors: [
      "static method 'foo' has too many lines (3). Maximum allowed is 2."
    ]
  ,
    # Test computed property names
    code: '''
      class A
        [foo +
                bar
        ]: (a) ->
          a
    '''
    options: [max: 2, skipComments: yes, skipBlankLines: no]
    errors: ['method has too many lines (4). Maximum allowed is 2.']
  ,
    # Test the IIFEs option includes IIFEs
    code: '''
      do (x) ->
        x = 0
        y = 0
        z = x + y
        foo = {}
        bar
    '''
    options: [max: 2, skipComments: yes, skipBlankLines: no, IIFEs: yes]
    errors: ['function has too many lines (6). Maximum allowed is 2.']
  ]
