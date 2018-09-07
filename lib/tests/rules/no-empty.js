// Generated by CoffeeScript 2.3.1
(function() {
  /**
   * @fileoverview Tests for no-empty rule.
   * @author Nicholas C. Zakas
   */
  'use strict';
  var RuleTester, rule, ruleTester;

  //------------------------------------------------------------------------------
  // Requirements
  //------------------------------------------------------------------------------
  rule = require('eslint/lib/rules/no-empty');

  ({RuleTester} = require('eslint'));

  //------------------------------------------------------------------------------
  // Tests
  //------------------------------------------------------------------------------
  ruleTester = new RuleTester({
    parser: '../../..'
  });

  ruleTester.run('no-empty', rule, {
    valid: [
      'if foo\n  bar()',
      'while foo\n  bar()',
      'try\n  foo()\ncatch ex\n  foo()',
      "switch foo\n  when 'foo'\n    break",
      'do ->',
      'foo = ->',
      'if foo\n  ;\n  ### empty ###',
      'while foo\n  ### empty ###\n  ;',
      'for x in y\n  ### empty ###\n  ;',
      'try\n  foo()\ncatch ex\n  ### empty ###',
      'try\n  foo()\ncatch ex\n  # empty',
      'try\n  foo()\nfinally\n  # empty',
      'try\n  foo()\nfinally\n  # test',
      'try\n  foo()\nfinally\n\n  # hi i am off no use',
      'try\n  foo()\ncatch ex\n  ### test111 ###',
      'if foo\n  bar()\nelse\n  # nothing in me',
      'if foo\n  bar()\nelse\n  ### ###',
      'if foo\n  bar()\nelse\n  #',
      {
        code: 'try\n  foo()\ncatch ex',
        options: [
          {
            allowEmptyCatch: true
          }
        ]
      },
      {
        code: 'try\n  foo()\ncatch ex\nfinally\n  bar()',
        options: [
          {
            allowEmptyCatch: true
          }
        ]
      }
    ],
    invalid: [
      {
        code: 'try\ncatch ex\n  throw ex',
        errors: [
          {
            messageId: 'unexpected',
            data: {
              type: 'block'
            },
            type: 'BlockStatement'
          }
        ]
      },
      {
        code: 'try\n  foo()\ncatch ex',
        errors: [
          {
            messageId: 'unexpected',
            data: {
              type: 'block'
            },
            type: 'BlockStatement'
          }
        ]
      },
      {
        code: 'try\n  foo()\ncatch ex\n  throw ex\nfinally',
        errors: [
          {
            messageId: 'unexpected',
            data: {
              type: 'block'
            },
            type: 'BlockStatement'
          }
        ]
      },
      {
        code: 'if foo\n  ;',
        errors: [
          {
            messageId: 'unexpected',
            data: {
              type: 'block'
            },
            type: 'BlockStatement'
          }
        ]
      },
      {
        code: 'while foo\n  ;',
        errors: [
          {
            messageId: 'unexpected',
            data: {
              type: 'block'
            },
            type: 'BlockStatement'
          }
        ]
      },
      {
        code: 'for x in y\n  ;',
        errors: [
          {
            messageId: 'unexpected',
            data: {
              type: 'block'
            },
            type: 'BlockStatement'
          }
        ]
      },
      {
        code: 'try\ncatch ex',
        options: [
          {
            allowEmptyCatch: true
          }
        ],
        errors: [
          {
            messageId: 'unexpected',
            data: {
              type: 'block'
            },
            type: 'BlockStatement'
          }
        ]
      },
      {
        code: 'try\n  foo()\ncatch ex\nfinally',
        options: [
          {
            allowEmptyCatch: true
          }
        ],
        errors: [
          {
            messageId: 'unexpected',
            data: {
              type: 'block'
            },
            type: 'BlockStatement'
          }
        ]
      },
      {
        code: 'try\ncatch ex\nfinally',
        options: [
          {
            allowEmptyCatch: true
          }
        ],
        errors: [
          {
            messageId: 'unexpected',
            data: {
              type: 'block'
            },
            type: 'BlockStatement'
          },
          {
            messageId: 'unexpected',
            data: {
              type: 'block'
            },
            type: 'BlockStatement'
          }
        ]
      },
      {
        code: 'try\n  foo()\ncatch ex\nfinally',
        errors: [
          {
            messageId: 'unexpected',
            data: {
              type: 'block'
            },
            type: 'BlockStatement'
          },
          {
            messageId: 'unexpected',
            data: {
              type: 'block'
            },
            type: 'BlockStatement'
          }
        ]
      }
    ]
  });

}).call(this);