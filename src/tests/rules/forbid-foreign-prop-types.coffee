###*
# @fileoverview Tests for forbid-foreign-prop-types
###
'use strict'

# -----------------------------------------------------------------------------
# Requirements
# -----------------------------------------------------------------------------

rule = require 'eslint-plugin-react/lib/rules/forbid-foreign-prop-types'
{RuleTester} = require 'eslint'
path = require 'path'

# -----------------------------------------------------------------------------
# Tests
# -----------------------------------------------------------------------------

ERROR_MESSAGE =
  'Using propTypes from another component is not safe because they may be removed in production builds'

ruleTester = new RuleTester parser: path.join __dirname, '../../..'
ruleTester.run 'forbid-foreign-prop-types', rule,
  valid: [
    code: 'import { propTypes } from "SomeComponent"'
  ,
    code:
      'import { propTypes as someComponentPropTypes } from "SomeComponent"'
  ,
    code: 'foo = propTypes'
  ,
    code: 'foo(propTypes)'
  ,
    code: 'foo + propTypes'
  ,
    code: 'foo = [propTypes]'
  ,
    code: 'foo = { propTypes }'
  ,
    code: 'Foo.propTypes = propTypes'
  ,
    code: 'Foo["propTypes"] = propTypes'
  ,
    code: '''
      propTypes = "bar"
      Foo[propTypes]
    '''
  ,
    code: '''
      Message = (props) => (<div>{props.message}</div>)
      Message.propTypes = {
        message: PropTypes.string
      }
      Hello = (props) => (<Message>Hello {props.name}</Message>)
      Hello.propTypes = {
        name: Message.propTypes.message
      }
    '''
    options: [allowInPropTypes: yes]
  ]

  invalid: [
    code: '''
      Foo = createReactClass({
        propTypes: Bar.propTypes,
        render: ->
          return <Foo className="bar" />
      })
    '''
    errors: [
      message: ERROR_MESSAGE
      type: 'Identifier'
    ]
  ,
    code: '''
      Foo = createReactClass({
        propTypes: Bar["propTypes"],
        render: ->
          return <Foo className="bar" />
      })
    '''
    errors: [
      message: ERROR_MESSAGE
      type: 'Literal'
    ]
  ,
    code: '''
      { propTypes } = SomeComponent
      Foo = createReactClass({
        propTypes,
        render: ->
          return <Foo className="bar" />
      })
    '''
    errors: [
      message: ERROR_MESSAGE
      type: 'Property'
    ]
  ,
    code: '''
      { propTypes: things, ...foo } = SomeComponent
      Foo = createReactClass({
        propTypes,
        render: ->
          return <Foo className="bar" />
      })
    '''
    # parser: 'babel-eslint'
    errors: [
      message: ERROR_MESSAGE
      type: 'Property'
    ]
  ,
    code: '''
      class MyComponent extends React.Component
        @fooBar = {
          baz: Qux.propTypes.baz
        }
    '''
    # parser: 'babel-eslint'
    errors: [
      message: ERROR_MESSAGE
      type: 'Identifier'
    ]
  ,
    code: '''
      { propTypes: typesOfProps } = SomeComponent
      Foo = createReactClass({
        propTypes: typesOfProps,
        render: ->
          return <Foo className="bar" />
      })
    '''
    errors: [
      message: ERROR_MESSAGE
      type: 'Property'
    ]
  ,
    code: '''
      Message = (props) => (<div>{props.message}</div>)
      Message.propTypes = {
        message: PropTypes.string
      }
      Hello = (props) => (<Message>Hello {props.name}</Message>)
      Hello.propTypes = {
        name: Message.propTypes.message
      }
    '''
    options: [allowInPropTypes: no]
    errors: [
      message: ERROR_MESSAGE
      type: 'Identifier'
    ]
  ]
