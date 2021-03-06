path = require 'path'
{test: testUtil} = require '../eslint-plugin-import-utils'

{RuleTester} = require 'eslint'

ruleTester = new RuleTester parser: path.join __dirname, '../../..'
rule = require 'eslint-plugin-import/lib/rules/no-duplicates'

test =
  if process.env.ESLINT_VERSION in ['3', '2']
    (t) -> testUtil Object.assign {}, t, output: t.code
  else
    testUtil

### eslint-disable coffee/no-template-curly-in-string ###

ruleTester.run 'no-duplicates', rule,
  valid: [
    test code: 'import "./malformed.koffee"'

    test
      code: '''
      import { x } from './foo'
      import { y } from './bar'
    '''

    # #86: every unresolved module should not show up as 'null' and duplicate
    test
      code: '''
        import foo from "234artaf"
        import { shoop } from "234q25ad"
      '''

    # # #225: ignore duplicate if is a flow type import
    # test
    #   code: "import { x } from './foo'; import type { y } from './foo'"
    #   parser: require.resolve 'babel-eslint'

    # #1107: Using different query strings that trigger different webpack loaders.
    test
      code: '''
        import x from './bar?optionX'
        import y from './bar?optionY'
      '''
      options: [considerQueryString: yes]
      settings: 'import/resolver': 'webpack'
    test
      code: '''
        import x from './foo'
        import y from './bar'
      '''
      options: [considerQueryString: yes]
      settings: 'import/resolver': 'webpack'
  ]
  invalid: [
    test
      code: '''
        import { x } from './foo'
        import { y } from './foo'
      '''
      output: "import { x , y } from './foo'\n"
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        import {x} from './foo'
        import {y} from './foo'
        import { z } from './foo'
      '''
      output: '''
        import {x,y, z } from './foo'\n\n
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    # # ensure resolved path results in warnings
    # test
    #   code: '''
    #     import { x } from './bar'
    #     import { y } from 'bar'
    #   '''
    #   output: '''
    #     import { x , y } from './bar'\n
    #   '''
    #   settings:
    #     'import/resolve':
    #       paths: [path.join process.cwd(), 'src', 'tests', 'fixtures', 'import']
    #   errors: 2 # path ends up hardcoded

    # #1107: Using different query strings that trigger different webpack loaders.
    test
      code: '''
        import x from './bar.coffee?optionX'
        import y from './bar?optionX'
      '''
      settings: 'import/resolver': 'webpack'
      errors: 2  # path ends up hardcoded
    test
      code: '''
        import x from './bar?optionX'
        import y from './bar?optionY'
      '''
      settings: 'import/resolver': 'webpack'
      errors: 2  # path ends up hardcoded

    # #1107: Using same query strings that trigger the same loader.
    test
      code: '''
        import x from './bar?optionX'
        import y from './bar.coffee?optionX'
      '''
      options: [considerQueryString: yes]
      settings: 'import/resolver': 'webpack'
      errors: 2  # path ends up hardcoded

    # #86: duplicate unresolved modules should be flagged
    test
      code: '''
        import foo from 'non-existent'
        import bar from 'non-existent'
      '''
      # Autofix bail because of different default import names.
      output: '''
        import foo from 'non-existent'
        import bar from 'non-existent'
      '''
      errors: [
        "'non-existent' imported multiple times."
        "'non-existent' imported multiple times."
      ]

      # test
      #   code: "import type { x } from './foo'; import type { y } from './foo'"
      #   output: "import type { x , y } from './foo'; "
      #   parser: require.resolve 'babel-eslint'
      #   errors: [
      #     "'./foo' imported multiple times."
      #     "'./foo' imported multiple times."
      #   ]

    test
      code: '''
        import './foo'
        import './foo'
      '''
      output: '''
        import './foo'\n
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        import { x, ### x ### } from './foo'
        import {#y
          y#y2
        } from './foo'
      '''
      output: '''
        import { x, ### x ### #y
          y#y2
        } from './foo'\n
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]
    test
      code: '''
        import {x} from './foo'
        import {} from './foo'
      '''
      output: '''
        import {x} from './foo'\n
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        import {x} from './foo'
        import {} from './foo'
        import {###c###} from './foo'
        import {y} from './foo'
      '''
      output: '''
        import {x###c###,y} from './foo'\n\n\n
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        import { } from './foo'
        import {x} from './foo'
      '''
      output: '''
        import { x} from './foo'\n
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        import './foo'
        import {x} from './foo'
      '''
      output: '''
        import {x} from './foo'\n
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        import'./foo'
        import {x} from './foo'
      '''
      output: '''
        import {x} from'./foo'\n
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

      # TODO: this autofix doesn't parse in Coffeescript
      # technically should override this rule to avoid this edge case
      # test
      #   code: '''
      #     import './foo'
      #     import { ###x###} from './foo'
      #     import {#y
      #     } from './foo'
      #     import {z} from './foo'
      #   '''
      #   output: '''
      #     import { ###x####y
      #     z} from './foo'\n\n\n
      #   '''
      #   errors: [
      #     "'./foo' imported multiple times."
      #     "'./foo' imported multiple times."
      #     "'./foo' imported multiple times."
      #     "'./foo' imported multiple times."
      #   ]

    test
      code: '''
        import './foo'
        import def, {x} from './foo'
      '''
      output: '''
        import def, {x} from './foo'\n
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        import './foo'
        import def from './foo'
      '''
      output: '''
        import def from './foo'\n
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        import {x} from './foo'
        import def from './foo'
      '''
      output: '''
        import def, {x} from './foo'\n
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        import{x} from './foo'
        import def from './foo'
      '''
      output: '''
        import def,{x} from './foo'\n
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        import {x} from './foo'
        import def, {y} from './foo'
      '''
      output: '''
        import def, {x,y} from './foo'\n
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        import * as ns from './foo'
        import {y} from './foo'
      '''
      # Autofix bail because first import is a namespace import.
      output: '''
        import * as ns from './foo'
        import {y} from './foo'
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        import {x} from './foo'
        import * as ns from './foo'
        import {y} from './foo'
        import './foo'
      '''
      # Autofix could merge some imports, but not the namespace import.
      output: '''
        import {x,y} from './foo'
        import * as ns from './foo'\n\n
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        # some-tool-disable-next-line
        import {x} from './foo'
        import {#y\n  y} from './foo'
      '''
      # Autofix bail because of comment.
      output: '''
        # some-tool-disable-next-line
        import {x} from './foo'
        import {#y\n  y} from './foo'
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        import {x} from './foo'
        # some-tool-disable-next-line
        import {y} from './foo'
      '''
      # Autofix bail because of comment.
      output: '''
        import {x} from './foo'
        # some-tool-disable-next-line
        import {y} from './foo'
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        import {x} from './foo' # some-tool-disable-line
        import {y} from './foo'
      '''
      # Autofix bail because of comment.
      output: '''
        import {x} from './foo' # some-tool-disable-line
        import {y} from './foo'
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        import {x} from './foo'
        import {y} from './foo' # some-tool-disable-line
      '''
      # Autofix bail because of comment.
      output: '''
        import {x} from './foo'
        import {y} from './foo' # some-tool-disable-line
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    # test
    #   code: '''
    #     import {x} from './foo'
    #     ### comment ### import {y} from './foo'
    #   '''
    #   # Autofix bail because of comment.
    #   output: '''
    #     import {x} from './foo'
    #     ### comment ### import {y} from './foo'
    #   '''
    #   errors: [
    #     "'./foo' imported multiple times."
    #     "'./foo' imported multiple times."
    #   ]

    test
      code: '''
        import {x} from './foo'
        import {y} from './foo' ### comment
        multiline ###
      '''
      # Autofix bail because of comment.
      output: '''
        import {x} from './foo'
        import {y} from './foo' ### comment
        multiline ###
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        import {x} from './foo'
        import {y} from './foo'
        # some-tool-disable-next-line
      '''
      # Not autofix bail.
      output: '''
        import {x,y} from './foo'

        # some-tool-disable-next-line
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        import {x} from './foo'
        # comment

        import {y} from './foo'
      '''
      # Not autofix bail.
      output: '''
        import {x,y} from './foo'
        # comment\n\n
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        import {x} from './foo'
        import### comment ###{y} from './foo'
      '''
      # Autofix bail because of comment.
      output: '''
        import {x} from './foo'
        import### comment ###{y} from './foo'
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        import {x} from './foo'
        import### comment ###'./foo'
      '''
      # Autofix bail because of comment.
      output: '''
        import {x} from './foo'
        import### comment ###'./foo'
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        import {x} from './foo'
        import{y}### comment ###from './foo'
      '''
      # Autofix bail because of comment.
      output: '''
        import {x} from './foo'
        import{y}### comment ###from './foo'
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

    test
      code: '''
        import {x} from './foo'
        import{y}from### comment ###'./foo'
      '''
      # Autofix bail because of comment.
      output: '''
        import {x} from './foo'
        import{y}from### comment ###'./foo'
      '''
      errors: [
        "'./foo' imported multiple times."
        "'./foo' imported multiple times."
      ]

      # test
      #   code: '''
      #     import {x} from
      #     # some-tool-disable-next-line
      #     './foo'
      #     import {y} from './foo'
      #   '''
      #   # Autofix bail because of comment.
      #   output: '''
      #     import {x} from
      #     # some-tool-disable-next-line
      #     './foo'
      #     import {y} from './foo'
      #   '''
      #   errors: [
      #     "'./foo' imported multiple times."
      #     "'./foo' imported multiple times."
      #   ]
  ]
