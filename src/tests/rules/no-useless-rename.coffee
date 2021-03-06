###*
# @fileoverview Disallow renaming import, export, and destructured assignments to the same name.
# @author Kai Cataldo
###

'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------

rule = require 'eslint/lib/rules/no-useless-rename'
{RuleTester} = require 'eslint'
path = require 'path'

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

ruleTester.run 'no-useless-rename', rule,
  valid: [
    '{foo} = obj'
    '{foo: bar} = obj'
    '{foo: bar, baz: qux} = obj'
    '{foo: {bar: baz}} = obj'
    '{foo, bar: {baz: qux}} = obj'
    "{'foo': bar} = obj"
    "{'foo': bar, 'baz': qux} = obj"
    "{'foo': {'bar': baz}} = obj"
    "{foo, 'bar': {'baz': qux}} = obj"
    "{['foo']: bar} = obj"
    "{['foo']: bar, ['baz']: qux} = obj"
    "{['foo']: {['bar']: baz}} = obj"
    "{foo, ['bar']: {['baz']: qux}} = obj"
    '{[foo]: foo} = obj'
    "{['foo']: foo} = obj"
    '{[foo]: bar} = obj'
    'func = ({foo}) ->'
    'func = ({foo: bar}) ->'
    'func = ({foo: bar, baz: qux}) ->'
    '({foo}) => {}'
    '({foo: bar}) => {}'
    '({foo: bar, baz: qui}) => {}'
    "import * as foo from 'foo'"
    "import foo from 'foo'"
    "import {foo} from 'foo'"
    "import {foo as bar} from 'foo'"
    "import {foo as bar, baz as qux} from 'foo'"
    "export {foo} from 'foo'"
    'export {foo as bar}'
    'export {foo as bar, baz as qux}'
    "export {foo as bar} from 'foo'"
    "export {foo as bar, baz as qux} from 'foo'"
    '{...stuff} = myObject'
    '{foo, ...stuff} = myObject'
    '{foo: bar, ...stuff} = myObject'
  ,
    # { ignoreDestructuring: true }
    code: '{foo: foo} = obj'
    options: [ignoreDestructuring: yes]
  ,
    code: '{foo: foo, bar: baz} = obj'
    options: [ignoreDestructuring: yes]
  ,
    code: '{foo: foo, bar: bar} = obj'
    options: [ignoreDestructuring: yes]
  ,
    # { ignoreImport: true }
    code: "import {foo as foo} from 'foo'"
    options: [ignoreImport: yes]
  ,
    code: "import {foo as foo, bar as baz} from 'foo'"
    options: [ignoreImport: yes]
  ,
    code: "import {foo as foo, bar as bar} from 'foo'"
    options: [ignoreImport: yes]
  ,
    # { ignoreExport: true }
    code: 'export {foo as foo}'
    options: [ignoreExport: yes]
  ,
    code: 'export {foo as foo, bar as baz}'
    options: [ignoreExport: yes]
  ,
    code: 'export {foo as foo, bar as bar}'
    options: [ignoreExport: yes]
  ,
    code: "export {foo as foo} from 'foo'"
    options: [ignoreExport: yes]
  ,
    code: "export {foo as foo, bar as baz} from 'foo'"
    options: [ignoreExport: yes]
  ,
    code: "export {foo as foo, bar as bar} from 'foo'"
    options: [ignoreExport: yes]
  ]

  invalid: [
    code: '{foo: foo} = obj'
    output: '{foo} = obj'
    errors: ['Destructuring assignment foo unnecessarily renamed.']
  ,
    code: '{a, foo: foo} = obj'
    output: '{a, foo} = obj'
    errors: ['Destructuring assignment foo unnecessarily renamed.']
  ,
    code: '{foo: foo, bar: baz} = obj'
    output: '{foo, bar: baz} = obj'
    errors: ['Destructuring assignment foo unnecessarily renamed.']
  ,
    code: '{foo: bar, baz: baz} = obj'
    output: '{foo: bar, baz} = obj'
    errors: ['Destructuring assignment baz unnecessarily renamed.']
  ,
    code: '{foo: foo, bar: bar} = obj'
    output: '{foo, bar} = obj'
    errors: [
      'Destructuring assignment foo unnecessarily renamed.'
      'Destructuring assignment bar unnecessarily renamed.'
    ]
  ,
    code: '{foo: {bar: bar}} = obj'
    output: '{foo: {bar}} = obj'
    errors: ['Destructuring assignment bar unnecessarily renamed.']
  ,
    code: '{foo: {bar: bar}, baz: baz} = obj'
    output: '{foo: {bar}, baz} = obj'
    errors: [
      'Destructuring assignment bar unnecessarily renamed.'
      'Destructuring assignment baz unnecessarily renamed.'
    ]
  ,
    code: "{'foo': foo} = obj"
    output: '{foo} = obj'
    errors: ['Destructuring assignment foo unnecessarily renamed.']
  ,
    code: "{'foo': foo, 'bar': baz} = obj"
    output: "{foo, 'bar': baz} = obj"
    errors: ['Destructuring assignment foo unnecessarily renamed.']
  ,
    code: "{'foo': bar, 'baz': baz} = obj"
    output: "{'foo': bar, baz} = obj"
    errors: ['Destructuring assignment baz unnecessarily renamed.']
  ,
    code: "{'foo': foo, 'bar': bar} = obj"
    output: '{foo, bar} = obj'
    errors: [
      'Destructuring assignment foo unnecessarily renamed.'
      'Destructuring assignment bar unnecessarily renamed.'
    ]
  ,
    code: "{'foo': {'bar': bar}} = obj"
    output: "{'foo': {bar}} = obj"
    errors: ['Destructuring assignment bar unnecessarily renamed.']
  ,
    code: "{'foo': {'bar': bar}, 'baz': baz} = obj"
    output: "{'foo': {bar}, baz} = obj"
    errors: [
      'Destructuring assignment bar unnecessarily renamed.'
      'Destructuring assignment baz unnecessarily renamed.'
    ]
  ,
    code: 'func = ({foo: foo}) ->'
    output: 'func = ({foo}) ->'
    errors: ['Destructuring assignment foo unnecessarily renamed.']
  ,
    code: 'func = ({foo: foo, bar: baz}) ->'
    output: 'func = ({foo, bar: baz}) ->'
    errors: ['Destructuring assignment foo unnecessarily renamed.']
  ,
    code: 'func = ({foo: bar, baz: baz}) ->'
    output: 'func = ({foo: bar, baz}) ->'
    errors: ['Destructuring assignment baz unnecessarily renamed.']
  ,
    code: 'func = ({foo: foo, bar: bar}) ->'
    output: 'func = ({foo, bar}) ->'
    errors: [
      'Destructuring assignment foo unnecessarily renamed.'
      'Destructuring assignment bar unnecessarily renamed.'
    ]
  ,
    code: '({foo: foo}) => {}'
    output: '({foo}) => {}'
    errors: ['Destructuring assignment foo unnecessarily renamed.']
  ,
    code: '({foo: foo, bar: baz}) => {}'
    output: '({foo, bar: baz}) => {}'
    errors: ['Destructuring assignment foo unnecessarily renamed.']
  ,
    code: '({foo: bar, baz: baz}) => {}'
    output: '({foo: bar, baz}) => {}'
    errors: ['Destructuring assignment baz unnecessarily renamed.']
  ,
    code: '({foo: foo, bar: bar}) => {}'
    output: '({foo, bar}) => {}'
    errors: [
      'Destructuring assignment foo unnecessarily renamed.'
      'Destructuring assignment bar unnecessarily renamed.'
    ]
  ,
    code: '{foo: foo, ...stuff} = myObject'
    output: '{foo, ...stuff} = myObject'
    errors: ['Destructuring assignment foo unnecessarily renamed.']
  ,
    code: '{foo: foo, bar: baz, ...stuff} = myObject'
    output: '{foo, bar: baz, ...stuff} = myObject'
    errors: ['Destructuring assignment foo unnecessarily renamed.']
  ,
    code: '{foo: foo, bar: bar, ...stuff} = myObject'
    output: '{foo, bar, ...stuff} = myObject'
    errors: [
      'Destructuring assignment foo unnecessarily renamed.'
      'Destructuring assignment bar unnecessarily renamed.'
    ]
  ,
    code: "import {foo as foo} from 'foo'"
    output: "import {foo} from 'foo'"
    errors: ['Import foo unnecessarily renamed.']
  ,
    code: "import {foo as foo, bar as baz} from 'foo'"
    output: "import {foo, bar as baz} from 'foo'"
    errors: ['Import foo unnecessarily renamed.']
  ,
    code: "import {foo as bar, baz as baz} from 'foo'"
    output: "import {foo as bar, baz} from 'foo'"
    errors: ['Import baz unnecessarily renamed.']
  ,
    code: "import {foo as foo, bar as bar} from 'foo'"
    output: "import {foo, bar} from 'foo'"
    errors: [
      'Import foo unnecessarily renamed.'
      'Import bar unnecessarily renamed.'
    ]
  ,
    code: 'export {foo as foo}'
    output: 'export {foo}'
    errors: ['Export foo unnecessarily renamed.']
  ,
    code: 'export {foo as foo, bar as baz}'
    output: 'export {foo, bar as baz}'
    errors: ['Export foo unnecessarily renamed.']
  ,
    code: 'export {foo as bar, baz as baz}'
    output: 'export {foo as bar, baz}'
    errors: ['Export baz unnecessarily renamed.']
  ,
    code: 'export {foo as foo, bar as bar}'
    output: 'export {foo, bar}'
    errors: [
      'Export foo unnecessarily renamed.'
      'Export bar unnecessarily renamed.'
    ]
  ,
    code: "export {foo as foo} from 'foo'"
    output: "export {foo} from 'foo'"
    errors: ['Export foo unnecessarily renamed.']
  ,
    code: "export {foo as foo, bar as baz} from 'foo'"
    output: "export {foo, bar as baz} from 'foo'"
    errors: ['Export foo unnecessarily renamed.']
  ,
    code: "export {foo as bar, baz as baz} from 'foo'"
    output: "export {foo as bar, baz} from 'foo'"
    errors: ['Export baz unnecessarily renamed.']
  ,
    code: "export {foo as foo, bar as bar} from 'foo'"
    output: "export {foo, bar} from 'foo'"
    errors: [
      'Export foo unnecessarily renamed.'
      'Export bar unnecessarily renamed.'
    ]
  ]
