###*
# @fileoverview Tests for no-unreachable rule.
# @author Joel Feenstra
###

'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------

rule = require 'eslint/lib/rules/no-unreachable'
{RuleTester} = require 'eslint'

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------

ruleTester = new RuleTester() # parser: '../../..'

ruleTester.run 'no-unreachable', rule,
  valid: [
    'function foo() { function bar() { return 1; } return bar(); }'
    'function foo() { return bar(); function bar() { return 1; } }'
    'function foo() { return x; var x; }'
    'function foo() { var x = 1; var y = 2; }'
    'function foo() { var x = 1; var y = 2; return; }'
    'while (true) { switch (foo) { case 1: x = 1; x = 2;} }'
    'while (true) { break; var x; }'
    'while (true) { continue; var x, y; }'
    "while (true) { throw 'message'; var x; }"
    'while (true) { if (true) break; var x = 1; }'
    'while (true) continue;'
    'switch (foo) { case 1: break; var x; }'
    "var x = 1; y = 2; throw 'uh oh'; var y;"
    'function foo() { var x = 1; if (x) { return; } x = 2; }'
    'function foo() { var x = 1; if (x) { } else { return; } x = 2; }'
    'function foo() { var x = 1; switch (x) { case 0: break; default: return; } x = 2; }'
    'function foo() { var x = 1; while (x) { return; } x = 2; }'
    'function foo() { var x = 1; for (x in {}) { return; } x = 2; }'
    'function foo() { var x = 1; try { return; } finally { x = 2; } }'
    'function foo() { var x = 1; for (;;) { if (x) break; } x = 2; }'
    'A: { break A; } foo()'
  ]
  invalid: [
    code: 'function foo() { return x; var x = 1; }'
    errors: [message: 'Unreachable code.', type: 'VariableDeclaration']
  ,
    code: 'function foo() { return x; var x, y = 1; }'
    errors: [message: 'Unreachable code.', type: 'VariableDeclaration']
  ,
    code: 'while (true) { continue; var x = 1; }'
    errors: [message: 'Unreachable code.', type: 'VariableDeclaration']
  ,
    code: 'function foo() { return; x = 1; }'
    errors: [message: 'Unreachable code.', type: 'ExpressionStatement']
  ,
    code: 'function foo() { throw error; x = 1; }'
    errors: [message: 'Unreachable code.', type: 'ExpressionStatement']
  ,
    code: 'while (true) { break; x = 1; }'
    errors: [message: 'Unreachable code.', type: 'ExpressionStatement']
  ,
    code: 'while (true) { continue; x = 1; }'
    errors: [message: 'Unreachable code.', type: 'ExpressionStatement']
  ,
    code: 'function foo() { switch (foo) { case 1: return; x = 1; } }'
    errors: [message: 'Unreachable code.', type: 'ExpressionStatement']
  ,
    code: 'function foo() { switch (foo) { case 1: throw e; x = 1; } }'
    errors: [message: 'Unreachable code.', type: 'ExpressionStatement']
  ,
    code: 'while (true) { switch (foo) { case 1: break; x = 1; } }'
    errors: [message: 'Unreachable code.', type: 'ExpressionStatement']
  ,
    code: 'while (true) { switch (foo) { case 1: continue; x = 1; } }'
    errors: [message: 'Unreachable code.', type: 'ExpressionStatement']
  ,
    code: "var x = 1; throw 'uh oh'; var y = 2;"
    errors: [message: 'Unreachable code.', type: 'VariableDeclaration']
  ,
    code:
      'function foo() { var x = 1; if (x) { return; } else { throw e; } x = 2; }'
    errors: [message: 'Unreachable code.', type: 'ExpressionStatement']
  ,
    code: 'function foo() { var x = 1; if (x) return; else throw -1; x = 2; }'
    errors: [message: 'Unreachable code.', type: 'ExpressionStatement']
  ,
    code: 'function foo() { var x = 1; try { return; } finally {} x = 2; }'
    errors: [message: 'Unreachable code.', type: 'ExpressionStatement']
  ,
    code: 'function foo() { var x = 1; try { } finally { return; } x = 2; }'
    errors: [message: 'Unreachable code.', type: 'ExpressionStatement']
  ,
    code: 'function foo() { var x = 1; do { return; } while (x); x = 2; }'
    errors: [message: 'Unreachable code.', type: 'ExpressionStatement']
  ,
    code:
      'function foo() { var x = 1; while (x) { if (x) break; else continue; x = 2; } }'
    errors: [message: 'Unreachable code.', type: 'ExpressionStatement']
  ,
    code: 'function foo() { var x = 1; for (;;) { if (x) continue; } x = 2; }'
    errors: [message: 'Unreachable code.', type: 'ExpressionStatement']
  ,
    code: 'function foo() { var x = 1; while (true) { } x = 2; }'
    errors: [message: 'Unreachable code.', type: 'ExpressionStatement']
  ,
    # Merge the warnings of continuous unreachable nodes.
    code: """
                function foo() {
                    return;

                    a();  // ← ERROR: Unreachable code. (no-unreachable)

                    b()   // ↑ ';' token is included in the unreachable code, so this statement will be merged.
                    // comment
                    c();  // ↑ ')' token is included in the unreachable code, so this statement will be merged.
                }
            """
    errors: [
      message: 'Unreachable code.'
      type: 'ExpressionStatement'
      line: 4
      column: 5
      endLine: 8
      endColumn: 9
    ]
  ,
    code: """
                function foo() {
                    return;

                    a();

                    if (b()) {
                        c()
                    } else {
                        d()
                    }
                }
            """
    errors: [
      message: 'Unreachable code.'
      type: 'ExpressionStatement'
      line: 4
      column: 5
      endLine: 10
      endColumn: 6
    ]
  ,
    code: """
                function foo() {
                    if (a) {
                        return
                        b();
                        c();
                    } else {
                        throw err
                        d();
                    }
                }
            """
    errors: [
      message: 'Unreachable code.'
      type: 'ExpressionStatement'
      line: 4
      column: 9
      endLine: 5
      endColumn: 13
    ,
      message: 'Unreachable code.'
      type: 'ExpressionStatement'
      line: 8
      column: 9
      endLine: 8
      endColumn: 13
    ]
  ,
    code: """
                function foo() {
                    if (a) {
                        return
                        b();
                        c();
                    } else {
                        throw err
                        d();
                    }
                    e();
                }
            """
    errors: [
      message: 'Unreachable code.'
      type: 'ExpressionStatement'
      line: 4
      column: 9
      endLine: 5
      endColumn: 13
    ,
      message: 'Unreachable code.'
      type: 'ExpressionStatement'
      line: 8
      column: 9
      endLine: 8
      endColumn: 13
    ,
      message: 'Unreachable code.'
      type: 'ExpressionStatement'
      line: 10
      column: 5
      endLine: 10
      endColumn: 9
    ]
  ]
