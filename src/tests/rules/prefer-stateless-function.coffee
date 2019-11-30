###*
# @fileoverview Enforce stateless components to be written as a pure function
# @author Yannick Croissant
###
'use strict'

# ------------------------------------------------------------------------------
# Requirements
# ------------------------------------------------------------------------------

rule = require '../../rules/prefer-stateless-function'
{RuleTester} = require 'eslint'
path = require 'path'

# ------------------------------------------------------------------------------
# Tests
# ------------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'
ruleTester.run 'prefer-stateless-function', rule,
  valid: [
    # Already a stateless function
    code: '''
        Foo = (props) ->
          return <div>{props.foo}</div>
      '''
  ,
    # Already a stateless (arrow) function
    code: 'Foo = ({foo}) => <div>{foo}</div>'
  ,
    # Extends from PureComponent and uses props
    code: '''
        class Foo extends React.PureComponent
          render: ->
            return <div>{this.props.foo}</div>
      '''
    options: [ignorePureComponents: yes]
  ,
    # Extends from PureComponent and uses context
    code: '''
        class Foo extends React.PureComponent
          render: ->
            return <div>{this.context.foo}</div>
      '''
    options: [ignorePureComponents: yes]
  ,
    # Extends from PureComponent in an expression context.
    code: '''
        Foo = class extends React.PureComponent
          render: ->
            return <div>{this.props.foo}</div>
      '''
    options: [ignorePureComponents: yes]
  ,
    # Has a lifecyle method
    code: '''
        class Foo extends React.Component
          shouldComponentUpdate: ->
            return false
          render: ->
            return <div>{this.props.foo}</div>
      '''
  ,
    # Has a state
    code: '''
        class Foo extends React.Component
          changeState: ->
            this.setState({foo: "clicked"})
          render: ->
            return <div onClick={this.changeState.bind(this)}>{this.state.foo || "bar"}</div>
      '''
  ,
    # Use refs
    code: '''
        class Foo extends React.Component
          doStuff: ->
            this.refs.foo.style.backgroundColor = "red"
          render: ->
            return <div ref="foo" onClick={this.doStuff}>{this.props.foo}</div>
      '''
  ,
    # Has an additional method
    code: '''
        class Foo extends React.Component
          doStuff: ->
          render: ->
            return <div>{this.props.foo}</div>
      '''
  ,
    # Has an empty (no super) constructor
    code: '''
        class Foo extends React.Component
          constructor: ->
          render: ->
            return <div>{this.props.foo}</div>
      '''
  ,
    # Has a constructor
    code: '''
        class Foo extends React.Component
          constructor: ->
            doSpecialStuffs()
          render: ->
            return <div>{this.props.foo}</div>
      '''
  ,
    # Has a constructor (2)
    code: '''
        class Foo extends React.Component
          constructor: ->
            foo
          render: ->
            return <div>{this.props.foo}</div>
      '''
  ,
    # Use this.bar
    code: '''
        class Foo extends React.Component
          render: ->
            <div>{@bar}</div>
      '''
  ,
    # parser: 'babel-eslint'
    # Use this.bar (destructuring)
    code: '''
        class Foo extends React.Component
          render: ->
            {props:{foo}, bar} = this
            return <div>{foo}</div>
      '''
  ,
    # parser: 'babel-eslint'
    # Use this[bar]
    code: '''
        class Foo extends React.Component
          render: ->
            return <div>{this[bar]}</div>
      '''
  ,
    # parser: 'babel-eslint'
    # Use this['bar']
    code: '''
        class Foo extends React.Component
          render: ->
            return <div>{this['bar']}</div>
      '''
  ,
    # parser: 'babel-eslint'
    # Can return null (ES6, React 0.14.0)
    code: '''
        class Foo extends React.Component
          render: ->
            if (!this.props.foo)
              return null
      '''
    # parser: 'babel-eslint'
    settings:
      react:
        version: '0.14.0'
  ,
    # Can return null (ES5, React 0.14.0)
    code: '''
        Foo = createReactClass({
          render: ->
            if (!this.props.foo)
              return null
            return <div>{this.props.foo}</div>
        })
      '''
    settings:
      react:
        version: '0.14.0'
  ,
    # Can return null (shorthand if in return, React 0.14.0)
    code: '''
        class Foo extends React.Component
          render: ->
            return if true then <div /> else null
      '''
    # parser: 'babel-eslint'
    settings:
      react:
        version: '0.14.0'
  ,
    code: '''
        export default (Component) => (
          class Test extends React.Component
            componentDidMount: ->
            render: ->
              return <Component />
        )
      '''
  ,
    # parser: 'babel-eslint'
    # Has childContextTypes
    code: '''
        class Foo extends React.Component
          render: ->
            return <div>{this.props.children}</div>
        Foo.childContextTypes = {
          color: PropTypes.string
        }
      '''
    # parser: 'babel-eslint'
  ]

  invalid: [
    # Only use this.props
    code: '''
        class Foo extends React.Component
          render: ->
            <div>{@props.foo}</div>
      '''
    errors: [message: 'Component should be written as a pure function']
  ,
    code: '''
        class Foo extends React.Component
          render: ->
            return <div>{this['props'].foo}</div>
      '''
    errors: [message: 'Component should be written as a pure function']
  ,
    code: '''
        class Foo extends React.PureComponent
          render: ->
            return <div>foo</div>
      '''
    options: [ignorePureComponents: yes]
    errors: [message: 'Component should be written as a pure function']
  ,
    code: '''
        class Foo extends React.PureComponent
          render: ->
            return <div>{this.props.foo}</div>
      '''
    errors: [message: 'Component should be written as a pure function']
  ,
    # ,
    #   code: """
    #       class Foo extends React.Component {
    #         static get displayName() {
    #           return 'Foo'
    #         }
    #         render() {
    #           return <div>{this.props.foo}</div>
    #         }
    #       }
    #     """
    #   # parser: 'babel-eslint'
    #   errors: [message: 'Component should be written as a pure function']
    code: '''
        class Foo extends React.Component
          @displayName = 'Foo'
          render: ->
            return <div>{this.props.foo}</div>
      '''
    # parser: 'babel-eslint'
    errors: [message: 'Component should be written as a pure function']
  ,
    # ,
    #   code: """
    #       class Foo extends React.Component {
    #         static get propTypes() {
    #           return {
    #             name: PropTypes.string
    #           }
    #         }
    #         render() {
    #           return <div>{this.props.foo}</div>
    #         }
    #       }
    #     """
    #   # parser: 'babel-eslint'
    #   errors: [message: 'Component should be written as a pure function']
    code: '''
        class Foo extends React.Component
          @propTypes = {
            name: PropTypes.string
          }
          render: ->
            return <div>{this.props.foo}</div>
      '''
    # parser: 'babel-eslint'
    errors: [message: 'Component should be written as a pure function']
  ,
    code: '''
        class Foo extends React.Component
          constructor: ->
            super()
          render: ->
            return <div>{this.props.foo}</div>
      '''
    # parser: 'babel-eslint'
    errors: [message: 'Component should be written as a pure function']
  ,
    code: '''
        class Foo extends React.Component
          render: ->
            {props:{foo}, context:{bar}} = this
            return <div>{this.props.foo}</div>
      '''
    errors: [message: 'Component should be written as a pure function']
  ,
    code: '''
        class Foo extends React.Component
          render: ->
            return null unless @props.foo
      '''
    # parser: 'babel-eslint'
    errors: [message: 'Component should be written as a pure function']
  ,
    code: '''
        Foo = createReactClass({
          render: ->
            if (!this.props.foo)
              return null
            return <div>{this.props.foo}</div>
        })
      '''
    errors: [message: 'Component should be written as a pure function']
  ,
    code: '''
        class Foo extends React.Component
          render: ->
            return if true then <div /> else null
      '''
    errors: [message: 'Component should be written as a pure function']
  ,
    code: '''
        class Foo extends React.Component
          @defaultProps = {
            foo: true
          }
          render: ->
            { foo } = this.props
            return if foo then <div /> else null
      '''
    # parser: 'babel-eslint'
    errors: [message: 'Component should be written as a pure function']
  ,
    # ,
    #   code: """
    #       class Foo extends React.Component {
    #         static get defaultProps() {
    #           return {
    #             foo: true
    #           }
    #         }
    #         render() {
    #           { foo } = this.props
    #           return foo ? <div /> : null
    #         }
    #       }
    #     """
    #   errors: [message: 'Component should be written as a pure function']
    code: '''
        class Foo extends React.Component
          render: ->
            { foo } = this.props
            return if foo then <div /> else null
        Foo.defaultProps = {
          foo: true
        }
      '''
    errors: [message: 'Component should be written as a pure function']
  ,
    code: '''
        class Foo extends React.Component
          @contextTypes = {
            foo: PropTypes.boolean
          }
          render: ->
            { foo } = this.context
            return if foo then <div /> else null
      '''
    # parser: 'babel-eslint'
    errors: [message: 'Component should be written as a pure function']
  ,
    # ,
    #   code: """
    #       class Foo extends React.Component {
    #         static get contextTypes() {
    #           return {
    #             foo: PropTypes.boolean
    #           }
    #         }
    #         render() {
    #           { foo } = this.context
    #           return foo ? <div /> : null
    #         }
    #       }
    #     """
    #   errors: [message: 'Component should be written as a pure function']
    code: '''
        class Foo extends React.Component
          render: ->
            { foo } = this.context
            return if foo then <div /> else null
        Foo.contextTypes = {
          foo: PropTypes.boolean
        }
      '''
    errors: [message: 'Component should be written as a pure function']
  ]
