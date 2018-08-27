// Generated by CoffeeScript 2.3.1
(function() {
  /**
   * @fileoverview Tests for no-sync.
   * @author Matt DuVall <http://www.mattduvall.com>
   */
  'use strict';
  var RuleTester, rule, ruleTester;

  //------------------------------------------------------------------------------
  // Requirements
  //------------------------------------------------------------------------------
  rule = require('eslint/lib/rules/no-sync');

  ({RuleTester} = require('eslint'));

  //------------------------------------------------------------------------------
  // Tests
  //------------------------------------------------------------------------------
  ruleTester = new RuleTester({
    parser: '../../..'
  });

  ruleTester.run('no-sync', rule, {
    valid: [
      'foo = fs.foo.foo()',
      {
        code: 'foo = fs.fooSync',
        options: [
          {
            allowAtRootLevel: true
          }
        ]
      },
      {
        code: 'if (true) then fs.fooSync()',
        options: [
          {
            allowAtRootLevel: true
          }
        ]
      }
    ],
    invalid: [
      {
        code: 'foo = fs.fooSync()',
        errors: [
          {
            message: "Unexpected sync method: 'fooSync'.",
            type: 'MemberExpression'
          }
        ]
      },
      {
        code: 'foo = fs.fooSync()',
        options: [
          {
            allowAtRootLevel: false
          }
        ],
        errors: [
          {
            message: "Unexpected sync method: 'fooSync'.",
            type: 'MemberExpression'
          }
        ]
      },
      {
        code: 'fs.fooSync() if yes',
        errors: [
          {
            message: "Unexpected sync method: 'fooSync'.",
            type: 'MemberExpression'
          }
        ]
      },
      {
        code: 'foo = fs.fooSync',
        errors: [
          {
            message: "Unexpected sync method: 'fooSync'.",
            type: 'MemberExpression'
          }
        ]
      },
      {
        code: 'someFunction = -> fs.fooSync()',
        errors: [
          {
            message: "Unexpected sync method: 'fooSync'.",
            type: 'MemberExpression'
          }
        ]
      },
      {
        code: 'someFunction = -> fs.fooSync()',
        options: [
          {
            allowAtRootLevel: true
          }
        ],
        errors: [
          {
            message: "Unexpected sync method: 'fooSync'.",
            type: 'MemberExpression'
          }
        ]
      },
      {
        code: '-> fs.fooSync()',
        options: [
          {
            allowAtRootLevel: true
          }
        ],
        errors: [
          {
            message: "Unexpected sync method: 'fooSync'.",
            type: 'MemberExpression'
          }
        ]
      }
    ]
  });

}).call(this);