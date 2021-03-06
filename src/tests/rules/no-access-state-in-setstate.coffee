###*
# @fileoverview Prevent usage of this.state within setState
# @author Rolf Erik Lekang, Jørgen Aaberg
###
'use strict'

# ------------------------------------------------------------------------------
# Requirements
# ------------------------------------------------------------------------------

rule = require '../../rules/no-access-state-in-setstate'
{RuleTester} = require 'eslint'
path = require 'path'

# ------------------------------------------------------------------------------
# Tests
# ------------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'
ruleTester.run 'no-access-state-in-setstate', rule,
  valid: [
    code: '''
      Hello = React.createClass
        onClick: ->
          @setState (state) => {value: state.value + 1}
    '''
  ,
    code: '''
      Hello = React.createClass({
        multiplyValue: (obj) ->
          return obj.value*2
        onClick: ->
          value = this.state.value
          this.multiplyValue({ value: value })
      })
    '''
  ,
    # issue 1559: don't crash
    code: '''
      SearchForm = createReactClass({
        render: ->
          return (
            <div>
              {(->
                if (this.state.prompt)
                  return <div>{this.state.prompt}</div>
              ).call(this)}
            </div>
          )
      })
    '''
  ,
    # issue 1604: allow this.state in callback
    code: '''
      Hello = React.createClass({
        onClick: ->
          this.setState({}, () => console.log(this.state))
      })
    '''
  ,
    code: '''
      Hello = React.createClass({
        onClick: ->
          this.setState({}, () => 1 + 1)
      })
    '''
  ,
    code: '''
      Hello = React.createClass({
        onClick: ->
          nextValueNotUsed = this.state.value + 1
          nextValue = 2
          this.setState({value: nextValue})
      })
    '''
  ,
    # https://github.com/yannickcr/eslint-plugin-react/pull/1611
    code: '''
      testFunction = ({a, b}) ->
    '''
  ]

  invalid: [
    code: '''
      Hello = React.createClass
        onClick: ->
          @setState value: @state.value + 1
    '''
    errors: [
      message: 'Use callback in setState when referencing the previous state.'
    ]
  ,
    code: '''
      Hello = React.createClass({
        onClick: ->
          this.setState => {value: this.state.value + 1}
      })
    '''
    errors: [
      message: 'Use callback in setState when referencing the previous state.'
    ]
  ,
    code: '''
      Hello = React.createClass({
        onClick: ->
          nextValue = this.state.value + 1
          this.setState({value: nextValue})
      })
    '''
    errors: [
      message: 'Use callback in setState when referencing the previous state.'
    ]
  ,
    code: '''
      Hello = React.createClass({
        onClick: ->
          {state, ...rest} = this
          this.setState({value: state.value + 1})
      })
    '''
    errors: [
      message: 'Use callback in setState when referencing the previous state.'
    ]
  ,
    code: '''
      nextState = (state) ->
        return {value: state.value + 1}
      Hello = React.createClass({
        onClick: ->
          this.setState(nextState(this.state))
      })
    '''
    errors: [
      message: 'Use callback in setState when referencing the previous state.'
    ]
  ,
    code: '''
      Hello = React.createClass({
        onClick: ->
          this.setState(this.state, () => 1 + 1)
      })
    '''
    errors: [
      message: 'Use callback in setState when referencing the previous state.'
    ]
  ,
    code: '''
      Hello = React.createClass({
        onClick: ->
          this.setState(this.state, () => console.log(this.state))
      })
    '''
    errors: [
      message: 'Use callback in setState when referencing the previous state.'
    ]
  ,
    code: '''
      Hello = React.createClass({
        nextState: ->
          return {value: this.state.value + 1}
        onClick: ->
          this.setState(nextState())
      })
    '''
    errors: [
      message: 'Use callback in setState when referencing the previous state.'
    ]
  ]
