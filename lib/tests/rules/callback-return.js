// Generated by CoffeeScript 2.3.1
(function() {
  /**
   * @fileoverview Tests for callback return rule.
   * @author Jamund Ferguson
   */
  'use strict';
  var RuleTester, rule, ruleTester;

  //------------------------------------------------------------------------------
  // Requirements
  //------------------------------------------------------------------------------
  rule = require('eslint/lib/rules/callback-return');

  ({RuleTester} = require('eslint'));

  //------------------------------------------------------------------------------
  // Tests
  //------------------------------------------------------------------------------
  ruleTester = new RuleTester({
    parser: '../../..'
  });

  ruleTester.run('callback-return', rule, {
    valid: [
      // callbacks inside of functions should return
      '(err) ->\n  if err\n    return callback(err)',
      '(err) ->\n  if err\n    return callback err\n  callback()',
      '(err) ->\n  if err\n    return ### confusing comment ### callback(err)\n  callback()',
      '(err) ->\n  if err\n    callback()\n    return',
      '(err) ->\n  if err\n    log()\n    callback()\n    return',
      '(err) ->\n  if err\n    callback()\n    return\n  return callback()',
      '(err) ->\n  if err\n    return callback()\n  else\n    return callback()',
      '(err) ->\n  if err\n    return callback()\n  else if x\n    return callback()',
      '(cb) ->\n  cb and cb()',
      "(next) ->\n  typeof next isnt 'undefined' and next()",
      "(next) ->\n  return next() if typeof next is 'function'",
      "->\n  switch x\n    when 'a'\n      return next()",
      '->\n  while x\n    return next()',
      '(err) ->\n  if err\n    obj.method err',
      // callback() all you want outside of a function
      'callback()',
      'callback()\ncallback()',
      'while x\n  move()',
      'if x\n  callback()',
      // arrow functions
      'x = (err) =>\n  if err\n    callback()\n    return',
      'x = (err) => callback(err)',
      'x = (err) =>\n  setTimeout => callback()',
      // classes
      'class x\n  horse: -> callback()',
      'class x\n  horse: ->\n    if err\n      return callback()\n    callback()',
      {
        // options (only warns with the correct callback name)
        code: '(err) ->\n  if err\n    callback err',
        options: [['cb']]
      },
      {
        code: '(err) ->\n  if err\n    callback err\n  next()',
        options: [['cb',
      'next']]
      },
      {
        code: 'a = (err) ->\n  if err then return next err else callback()',
        options: [['cb',
      'next']]
      },
      {
        // allow object methods (https://github.com/eslint/eslint/issues/4711)
        code: '(err) ->\n  if err\n    return obj.method err',
        options: [['obj.method']]
      },
      {
        code: '(err) ->\n  if err\n    return obj.prop.method err',
        options: [['obj.prop.method']]
      },
      {
        code: '(err) ->\n  if err\n    return obj.prop.method err\n  otherObj.prop.method()',
        options: [['obj.prop.method',
      'otherObj.prop.method']]
      },
      {
        code: '(err) ->\n  if err then callback err',
        options: [['obj.method']]
      },
      {
        code: '(err) -> otherObj.method err if err',
        options: [['obj.method']]
      },
      {
        code: '(err) ->\n  if err\n    #comment\n    return obj.method(err)',
        options: [['obj.method']]
      },
      {
        code: '(err) ->\n  if err\n    return obj.method err #comment',
        options: [['obj.method']]
      },
      {
        code: '(err) ->\n  if err\n    return obj.method err ###comment###',
        options: [['obj.method']]
      },
      {
        // only warns if object of MemberExpression is an Identifier
        code: '(err) ->\n  if err\n    obj().method err',
        options: [['obj().method']]
      },
      {
        code: '(err) ->\n  if err\n    obj.prop().method err',
        options: [['obj.prop().method']]
      },
      {
        code: '(err) ->\n  if (err) then obj().prop.method(err)',
        options: [['obj().prop.method']]
      },
      {
        // does not warn if object of MemberExpression is invoked
        code: '(err) -> if (err) then obj().method(err)',
        options: [['obj.method']]
      },
      {
        code: '(err) ->\n  if err\n    obj().method(err)\n  obj.method()',
        options: [['obj.method']]
      },
      //  known bad examples that we know we are ignoring
      '(err) ->\n  if err\n    setTimeout callback, 0\n  callback()', // callback() called twice
      '(err) ->\n  if err\n    process.nextTick (err) -> callback()\n  callback()' // callback() called twice
    ],
    invalid: [
      {
        code: '(err) ->\n  if err\n    callback err',
        errors: [
          {
            messageId: 'missingReturn',
            line: 3,
            column: 5,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        code: "(callback) ->\n  if typeof callback isnt 'undefined'\n    callback()",
        errors: [
          {
            messageId: 'missingReturn',
            line: 3,
            column: 5,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        code: '(callback) ->\n  if err\n    callback()\n    horse && horse()',
        errors: [
          {
            messageId: 'missingReturn',
            line: 3,
            column: 5,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        code: 'x =\n  x: (err) ->\n    if err\n      callback err',
        errors: [
          {
            messageId: 'missingReturn',
            line: 4,
            column: 7,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        code: '(err) ->\n  if err\n    log()\n    callback err',
        errors: [
          {
            messageId: 'missingReturn',
            line: 4,
            column: 5,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        code: 'x = {\n  x: (err) ->\n    if err\n      callback && callback(err)\n}',
        errors: [
          {
            messageId: 'missingReturn',
            line: 4,
            column: 19,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        code: '(err) ->\n  callback(err)\n  callback()',
        errors: [
          {
            messageId: 'missingReturn',
            line: 2,
            column: 3,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        code: '(err) ->\n  callback(err)\n  horse()',
        errors: [
          {
            messageId: 'missingReturn',
            line: 2,
            column: 3,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        code: '(err) ->\n  if err\n    callback(err)\n    horse()\n    return',
        errors: [
          {
            messageId: 'missingReturn',
            line: 3,
            column: 5,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        code: '(err) ->\n  if err\n    callback(err)\n  else if x\n    callback(err)\n    return',
        errors: [
          {
            messageId: 'missingReturn',
            line: 3,
            column: 5,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        code: '(err) ->\n  if (err)\n    return callback()\n  else if (abc)\n    callback()\n  else\n    return callback()',
        errors: [
          {
            messageId: 'missingReturn',
            line: 5,
            column: 5,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        code: 'class x\n  horse: ->\n    if err\n      callback()\n    callback()',
        errors: [
          {
            messageId: 'missingReturn',
            line: 4,
            column: 7,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        // generally good behavior which we must not allow to keep the rule simple
        code: '(err) ->\n  if err\n    callback()\n  else\n    callback()',
        errors: [
          {
            messageId: 'missingReturn',
            line: 3,
            column: 5,
            nodeType: 'CallExpression'
          },
          {
            messageId: 'missingReturn',
            line: 5,
            column: 5,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        code: '(err) ->\n  if err\n    return callback()\n  else\n    callback()',
        errors: [
          {
            messageId: 'missingReturn',
            line: 5,
            column: 5,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        code: "->\n  switch x\n    when 'horse'\n      callback()",
        errors: [
          {
            messageId: 'missingReturn',
            line: 4,
            column: 7,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        code: "a = ->\n  switch x\n    when 'horse'\n      move()",
        options: [['move']],
        errors: [
          {
            messageId: 'missingReturn',
            line: 4,
            column: 7,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        // loops
        code: 'x = ->\n  while x\n    move()',
        options: [['move']],
        errors: [
          {
            messageId: 'missingReturn',
            line: 3,
            column: 5,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        code: '(err) ->\n  if err\n    obj.method err',
        options: [['obj.method']],
        errors: [
          {
            messageId: 'missingReturn',
            line: 3,
            column: 5,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        code: '(err) ->\n  obj.prop.method err if err',
        options: [['obj.prop.method']],
        errors: [
          {
            messageId: 'missingReturn',
            line: 2,
            column: 3,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        code: '(err) ->\n  if err\n    obj.prop.method err\n  otherObj.prop.method()',
        options: [['obj.prop.method',
      'otherObj.prop.method']],
        errors: [
          {
            messageId: 'missingReturn',
            line: 3,
            column: 5,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        code: '(err) ->\n  if (err)\n    #comment\n    obj.method err',
        options: [['obj.method']],
        errors: [
          {
            messageId: 'missingReturn',
            line: 4,
            column: 5,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        code: '(err) ->\n  if err\n    obj.method err ###comment###',
        options: [['obj.method']],
        errors: [
          {
            messageId: 'missingReturn',
            line: 3,
            column: 5,
            nodeType: 'CallExpression'
          }
        ]
      },
      {
        code: '(err) ->\n  if err\n    obj.method err #comment',
        options: [['obj.method']],
        errors: [
          {
            messageId: 'missingReturn',
            line: 3,
            column: 5,
            nodeType: 'CallExpression'
          }
        ]
      }
    ]
  });

}).call(this);