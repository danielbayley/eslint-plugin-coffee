###*
# @fileoverview No color literals used in styles
# @author Aaron Greenwald
###

'use strict'

# ------------------------------------------------------------------------------
# Requirements
# ------------------------------------------------------------------------------

rule = require '../../rules/no-color-literals'
{RuleTester} = require 'eslint'
path = require 'path'

# ------------------------------------------------------------------------------
# Tests
# ------------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

tests =
  valid: [
    code: '''
        $red = 'red'
        $blue = 'blue'
        styles = StyleSheet.create({
            style1: {
                color: $red,
            },
            style2: {
                color: $blue,
            }
        })
        export default class MyComponent extends Component
            render: ->
                isDanger = true
                return <View 
                           style={[styles.style1, if isDanger then styles.style1 else styles.style2]}
                       />
      '''
  ,
    code: '''
        styles = StyleSheet.create({
            style1: {
                color: $red,
            },
            style2: {
                color: $blue,
            }
        })
        export default class MyComponent extends Component
            render: ->
                trueColor = '#fff'
                falseColor = '#000' 
                <View 
                   style={[
                     style1, 
                     this.state.isDanger and {color: falseColor}, 
                     {color: if someBoolean then trueColor else falseColor }]} 
                   />
      '''
  ]
  invalid: [
    code: '''
        Hello = React.createClass({
          render: ->
            return <Text style={{backgroundColor: '#FFFFFF', opacity: 0.5}}>
              Hello {this.props.name}
             </Text>
        })
      '''
    errors: [message: "Color literal: { backgroundColor: '#FFFFFF' }"]
  ,
    code: '''
        Hello = React.createClass({
          render: ->
            return <Text style={{backgroundColor: '#FFFFFF', opacity: this.state.opacity}}>
              Hello {this.props.name}
             </Text>
        })
      '''
    errors: [message: "Color literal: { backgroundColor: '#FFFFFF' }"]
  ,
    code: '''
        styles = StyleSheet.create({
          text: {fontColor: '#000'}
        })
        Hello = React.createClass({
          render: ->
            return <Text style={{opacity: this.state.opacity, height: 12, fontColor: styles.text}}>
              Hello {this.props.name}
             </Text>
        })
      '''
    errors: [message: "Color literal: { fontColor: '#000' }"]
  ,
    code: '''
        Hello = React.createClass({
          render: ->
            return <Text style={[styles.text, {backgroundColor: '#FFFFFF'}]}>
              Hello {this.props.name}
             </Text>
        })
      '''
    errors: [message: "Color literal: { backgroundColor: '#FFFFFF' }"]
  ,
    code: '''
        Hello = React.createClass({
          render: ->
            someBoolean = false 
            return <Text style={[styles.text, someBoolean && {backgroundColor: '#FFFFFF'}]}>
              Hello {this.props.name}
             </Text>
        })
      '''
    errors: [message: "Color literal: { backgroundColor: '#FFFFFF' }"]
  ,
    code: '''
        styles = StyleSheet.create({
            style1: {
                color: 'red',
            },
            # this is illegal even though it's not used anywhere
            style2: {
                borderBottomColor: 'blue',
            }
        })
        export default class MyComponent extends Component
            render: ->
                return <View 
                   style={[
                     style1, 
                     this.state.isDanger && styles.style1, 
                     {backgroundColor: if someBoolean then '#fff' else '#000'}
                   ]} 
                   />
      '''
    errors: [
      message: "Color literal: { color: 'red' }"
    ,
      message: "Color literal: { borderBottomColor: 'blue' }"
    ,
      message: '''Color literal: { backgroundColor: "if someBoolean then '#fff' else '#000'" }''' #eslint-disable-line
    ]
  ]

ruleTester.run 'no-color-literals', rule, tests
