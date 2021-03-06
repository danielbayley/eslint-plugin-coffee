path = require 'path'
{test, SYNTAX_CASES} = require '../eslint-plugin-import-utils'
{RuleTester} = require 'eslint'

{CASE_SENSITIVE_FS} = require 'eslint-module-utils/resolve'

ruleTester = new RuleTester parser: path.join __dirname, '../../..'
rule = require 'eslint-plugin-import/lib/rules/default'

ruleTester.run 'default', rule,
  valid: [
    test code: 'import "./malformed.koffee"'

    test code: 'import foo from "./empty-folder"'
    test code: 'import { foo } from "./default-export"'
    test code: 'import foo from "./default-export"'
    test code: 'import foo from "./mixed-exports"'
    test code: 'import bar from "./default-export"'
    test code: 'import CoolClass from "./default-class";'
    test code: 'import bar, { baz } from "./default-export"'

    # core modules always have a default
    test code: 'import crypto from "crypto"'

    test code: 'import common from "./common"'

    # # es7 export syntax
    # test
    #   code: 'export bar from "./bar"'
    #   parser: require.resolve 'babel-eslint'
    test code: 'export { default as bar } from "./bar"'
    # test
    #   code: 'export bar, { foo } from "./bar"'
    #   parser: require.resolve 'babel-eslint'
    test code: 'export { default as bar, foo } from "./bar"'
    # test
    #   code: 'export bar, * as names from "./bar"'
    #   parser: require.resolve 'babel-eslint'

    # sanity check
    test code: 'export {a} from "./named-exports"'
    # test
    #   code: 'import twofer from "./trampoline"'
    #   parser: require.resolve 'babel-eslint'

    # jsx
    test
      code: 'import MyCoolComponent from "./jsx/MyCoolComponent.coffee"'
      # parserOptions:
      #   sourceType: 'module'
      #   ecmaVersion: 6
      #   ecmaFeatures: jsx: yes

    # #54: import of named export default
    test code: 'import foo from "./named-default-export"'

    # #94: redux export of execution result,
    test code: 'import connectedApp from "./redux"'
    test
      code: 'import App from "./jsx/App"'
      # parserOptions:
      #   ecmaFeatures: jsx: yes, modules: yes

    # from no-errors
    test
      code: "import Foo from './jsx/FooES7.coffee'"
      # parser: require.resolve 'babel-eslint'

      # # #545: more ES7 cases
      # test
      #   code: "import bar from './default-export-from.js';"
      #   parser: require.resolve 'babel-eslint'
    test
      code: "import bar from './default-export-from-named.js';"
      # parser: require.resolve 'babel-eslint'
    test
      code: "import bar from './default-export-from-ignored.coffee'"
      settings: 'import/ignore': ['common']
      # parser: require.resolve 'babel-eslint'
      # test
      #   code: "export bar from './default-export-from-ignored.js';"
      #   settings: 'import/ignore': ['common']
      #   parser: require.resolve 'babel-eslint'

    ...SYNTAX_CASES
  ]

  invalid: [
    test
      # code: "import Foo from './jsx/FooES7.js';"
      code: "import Foo from './malformed.koffee'"
      errors: [
        "Parse errors in imported module './malformed.koffee': unexpected implicit function call (1:8)"
      ]
    test
      code: 'import baz from "./named-exports"'
      errors: [
        message:
          'No default export found in imported module "./named-exports".'
        type: 'ImportDefaultSpecifier'
      ]

      # test
      #   code: "import Foo from './jsx/FooES7.js';"
      #   errors: [
      #     "Parse errors in imported module './jsx/FooES7.js': Unexpected token = (6:16)"
      #   ]

      # # es7 export syntax
      # test
      #   code: 'export baz from "./named-exports"'
      #   parser: require.resolve 'babel-eslint'
      #   errors: ['No default export found in imported module "./named-exports".']
      # test
      #   code: 'export baz, { bar } from "./named-exports"'
      #   parser: require.resolve 'babel-eslint'
      #   errors: ['No default export found in imported module "./named-exports".']
      # test
      #   code: 'export baz, * as names from "./named-exports"'
      #   parser: require.resolve 'babel-eslint'
      #   errors: ['No default export found in imported module "./named-exports".']
      # # exports default from a module with no default
      # test
      #   code: 'import twofer from "./broken-trampoline"'
      #   parser: require.resolve 'babel-eslint'
      #   errors: [
      #     'No default export found in imported module "./broken-trampoline".'
      #   ]

    # #328: * exports do not include default
    test
      code: 'import barDefault from "./re-export"'
      errors: ['No default export found in imported module "./re-export".']
  ]

# #311: import of mismatched case
unless CASE_SENSITIVE_FS
  ruleTester.run 'default (path case-insensitivity)', rule,
    valid: [test code: 'import foo from "./jsx/MyUncoolComponent.jsx"']
    invalid: [
      test
        code: 'import bar from "./Named-Exports"'
        errors: [
          'No default export found in imported module "./Named-Exports".'
        ]
    ]
