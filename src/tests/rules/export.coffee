{RuleTester} = require 'eslint'
path = require 'path'

ruleTester = new RuleTester parser: path.join __dirname, '../../..'
rule = require '../../rules/export'

test = (x) -> x

ruleTester.run 'export', rule,
  valid: [
    test code: 'import "./malformed.js"'

    # default
    test
      code: '''
      foo = "foo"
      export default foo
    '''
    test
      code: '''
      export foo = "foo"
      export bar = "bar"
    '''
    # test code: 'export foo = "foo", bar = "bar"'
    # test code: 'export { foo, bar } = object'
    # test code: 'export [ foo, bar ] = array'
    # test code: 'export { foo, bar } = object'
    # test code: 'export [ foo, bar ] = array'
    test code: 'export { foo, foo as bar }'
    test
      code: '''
      export { bar }
      export * from "./export-all"
    '''
    test code: 'export * from "./export-all"'
    test code: 'export * from "./does-not-exist"'

    # #328: "export * from" does not export a default
    test
      code: '''
      export default foo
      export * from "./bar"
    '''
  ]

  invalid: [
    # multiple defaults
    test
      code: '''
        export default foo
        export default bar
      '''
      errors: ['Multiple default exports.', 'Multiple default exports.']
    test
      code: '''
        export default foo = ->
        export default bar = ->
      '''
      errors: ['Multiple default exports.', 'Multiple default exports.']
    test
      code: '''
        export foo = ->
        export { bar as foo }
      '''
      errors: [
        "Multiple exports of name 'foo'."
        "Multiple exports of name 'foo'."
      ]
    test
      code: '''
        export {foo}
        export {foo}
      '''
      errors: [
        "Multiple exports of name 'foo'."
        "Multiple exports of name 'foo'."
      ]
    test
      code: '''
        export {foo}
        export {bar as foo}
      '''
      errors: [
        "Multiple exports of name 'foo'."
        "Multiple exports of name 'foo'."
      ]
    test
      code: '''
        export foo = "foo"
        export foo = "bar"
      '''
      errors: [
        "Multiple exports of name 'foo'."
        "Multiple exports of name 'foo'."
      ]
      # test
      #   code: '''
      #     export { foo }
      #     export * from "./export-all"
      #   '''
      #   errors: [
      #     "Multiple exports of name 'foo'."
      #     "Multiple exports of name 'foo'."
      #   ]
      # test({ code: 'export * from "./default-export"'
      #      , errors: [{ message: 'No named exports found in module ' +
      #                            '\'./default-export\'.'
      #                 , type: 'Literal' }] }),

      # note: Espree bump to Acorn 4+ changed this test's error message.
      #       `npm up` first if it's failing.
      # test
      #   code: 'export * from "./malformed.js"'
      #   errors: [
      #     message:
      #       "Parse errors in imported module './malformed.js': 'return' outside of function (1:1)"
      #     type: 'Literal'
      #   ]

      # test({
      #   code: 'export { foo, bar } = object export foo = "bar"',
      #   errors: ['Parsing error: Duplicate export \'foo\''],
      # }),
      # test({
      #   code: 'export { bar: { foo } } = object export foo = "bar"',
      #   errors: ['Parsing error: Duplicate export \'foo\''],
      # }),
      # test({
      #   code: 'export [ foo, bar ] = array export bar = "baz"',
      #   errors: ['Parsing error: Duplicate export \'bar\''],
      # }),
      # test({
      #   code: 'export [ foo, /*sparse*/, { bar } ] = array export bar = "baz"',
      #   errors: ['Parsing error: Duplicate export \'bar\''],
      # }),

      # #328: "export * from" does not export a default
      # test
      #   code: 'export * from "./default-export"'
      #   errors: ["No named exports found in module './default-export'."]
  ]
