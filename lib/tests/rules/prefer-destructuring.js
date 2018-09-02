// Generated by CoffeeScript 2.3.1
(function() {
  /**
   * @fileoverview Prefer destructuring from arrays and objects
   * @author Alex LaFroscia
   */
  'use strict';
  var RuleTester, rule, ruleTester;

  //------------------------------------------------------------------------------
  // Requirements
  //------------------------------------------------------------------------------
  rule = require('../../rules/prefer-destructuring');

  ({RuleTester} = require('eslint'));

  //------------------------------------------------------------------------------
  // Tests
  //------------------------------------------------------------------------------
  ruleTester = new RuleTester({
    parser: '../../..'
  });

  ruleTester.run('prefer-destructuring', rule, {
    valid: [
      '[foo] = array',
      '{ foo } = object',
      'foo',
      {
        // Ensure that the default behavior does not require desturcturing when renaming
        code: 'foo = object.bar',
        options: [
          {
            object: true
          }
        ]
      },
      {
        code: 'foo = object.bar',
        options: [
          {
            object: true
          },
          {
            enforceForRenamedProperties: false
          }
        ]
      },
      {
        code: 'foo = object[bar]',
        options: [
          {
            object: true
          },
          {
            enforceForRenamedProperties: false
          }
        ]
      },
      {
        code: '{ bar: foo } = object',
        options: [
          {
            object: true
          },
          {
            enforceForRenamedProperties: true
          }
        ]
      },
      {
        code: '{ [bar]: foo } = object',
        options: [
          {
            object: true
          },
          {
            enforceForRenamedProperties: true
          }
        ]
      },
      {
        code: 'foo = array[0]',
        options: [
          {
            array: false
          }
        ]
      },
      {
        code: 'foo = object.foo',
        options: [
          {
            object: false
          }
        ]
      },
      {
        code: "foo = object['foo']",
        options: [
          {
            object: false
          }
        ]
      },
      '({ foo } = object)',
      {
        // Fix #8654
        code: 'foo = array[0]',
        options: [
          {
            array: false
          },
          {
            enforceForRenamedProperties: true
          }
        ]
      },
      '[foo] = array',
      'foo += array[0]',
      'foo += bar.foo',
      'class Foo extends Bar\n  @foo: -> \n    foo = super.foo',
      'foo = bar[foo]',
      'foo = bar[foo]',
      'foo = object?.foo',
      "foo = object?['foo']"
    ],
    invalid: [
      {
        code: 'foo = array[0]',
        errors: [
          {
            message: 'Use array destructuring.'
          }
        ]
      },
      {
        code: 'foo = object.foo',
        errors: [
          {
            message: 'Use object destructuring.'
          }
        ]
      },
      {
        code: 'foobar = object.bar',
        options: [
          {
            object: true
          },
          {
            enforceForRenamedProperties: true
          }
        ],
        errors: [
          {
            message: 'Use object destructuring.'
          }
        ]
      },
      {
        code: 'foo = object[bar]',
        options: [
          {
            object: true
          },
          {
            enforceForRenamedProperties: true
          }
        ],
        errors: [
          {
            message: 'Use object destructuring.'
          }
        ]
      },
      {
        code: "foo = object['foo']",
        errors: [
          {
            message: 'Use object destructuring.'
          }
        ]
      },
      {
        code: 'foo = array[0]',
        options: [
          {
            array: true
          },
          {
            enforceForRenamedProperties: true
          }
        ],
        errors: [
          {
            message: 'Use array destructuring.'
          }
        ]
      },
      {
        code: 'foo = array[0]',
        options: [
          {
            array: true
          }
        ],
        errors: [
          {
            message: 'Use array destructuring.'
          }
        ]
      },
      {
        code: 'class Foo extends Bar\n  @foo: -> bar = super.foo.bar',
        errors: [
          {
            message: 'Use object destructuring.'
          }
        ]
      }
    ]
  });

}).call(this);