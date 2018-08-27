// Generated by CoffeeScript 2.3.1
(function() {
  /**
   * @fileoverview Tests for max-nested-callbacks rule.
   * @author Ian Christian Myers
   */
  'use strict';
  /**
   * Generates a code string with the specified number of nested callbacks.
   * @param {int} times The number of times to nest the callbacks.
   * @returns {string} Code with the specified number of nested callbacks
   * @private
   */
  var CLOSING, OPENING, RuleTester, nestFunctions, rule, ruleTester;

  //------------------------------------------------------------------------------
  // Requirements
  //------------------------------------------------------------------------------
  rule = require('eslint/lib/rules/max-nested-callbacks');

  ({RuleTester} = require('eslint'));

  OPENING = 'foo(-> ';

  CLOSING = ')';

  nestFunctions = function(times) {
    var closings, i, openings;
    openings = '';
    closings = '';
    i = 0;
    while (i < times) {
      openings += OPENING;
      closings += CLOSING;
      i++;
    }
    return openings + closings;
  };

  //------------------------------------------------------------------------------
  // Tests
  //------------------------------------------------------------------------------
  ruleTester = new RuleTester({
    parser: '../../..'
  });

  ruleTester.run('max-nested-callbacks', rule, {
    valid: [
      {
        code: 'foo -> bar thing, (data) ->',
        options: [3]
      },
      {
        code: 'foo = ->\nbar ->\n  baz ->\n    qux foo',
        options: [2]
      },
      {
        code: 'fn ->, ->, ->',
        options: [2]
      },
      nestFunctions(10),
      {
        // object property options
        code: 'foo -> bar thing, (data) ->',
        options: [
          {
            max: 3
          }
        ]
      }
    ],
    invalid: [
      {
        code: 'foo -> bar thing, (data) -> baz ->',
        options: [2],
        errors: [
          {
            message: 'Too many nested callbacks (3). Maximum allowed is 2.',
            type: 'FunctionExpression'
          }
        ]
      },
      {
        code: 'foo -> if isTrue then bar (data) -> baz ->',
        options: [2],
        errors: [
          {
            message: 'Too many nested callbacks (3). Maximum allowed is 2.',
            type: 'FunctionExpression'
          }
        ]
      },
      {
        code: nestFunctions(11),
        errors: [
          {
            message: 'Too many nested callbacks (11). Maximum allowed is 10.',
            type: 'FunctionExpression'
          }
        ]
      },
      {
        // object property options
        code: 'foo -> bar thing, (data) -> baz ->',
        options: [
          {
            max: 2
          }
        ],
        errors: [
          {
            message: 'Too many nested callbacks (3). Maximum allowed is 2.',
            type: 'FunctionExpression'
          }
        ]
      }
    ]
  });

}).call(this);