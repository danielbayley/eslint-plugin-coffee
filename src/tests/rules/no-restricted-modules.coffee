###*
# @fileoverview Tests for no-restricted-modules.
# @author Christian Schulz
###

'use strict'

#------------------------------------------------------------------------------
# Requirements
#------------------------------------------------------------------------------

rule = require 'eslint/lib/rules/no-restricted-modules'
{RuleTester} = require 'eslint'
path = require 'path'

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------

ruleTester = new RuleTester parser: path.join __dirname, '../../..'

ruleTester.run 'no-restricted-modules', rule,
  valid: [
    code: 'require("fs")', options: ['crypto']
  ,
    code: 'require("path")', options: ['crypto', 'stream', 'os']
  ,
    'require("fs ")'
  ,
    code: 'require(2)', options: ['crypto']
  ,
    code: 'require(foo)', options: ['crypto']
  ,
    code: "foo = bar('crypto')", options: ['crypto']
  ,
    code: 'require("foo/bar")', options: ['foo']
  ,
    code: 'withPaths = require("foo/bar")'
    options: [paths: ['foo', 'bar']]
  ,
    code: 'withPatterns = require("foo/bar")'
    options: [patterns: ['foo/c*']]
  ,
    code: 'withPatternsAndPaths = require("foo/bar")'
    options: [paths: ['foo'], patterns: ['foo/c*']]
  ,
    code: 'withGitignores = require("foo/bar")'
    options: [paths: ['foo'], patterns: ['foo/*', '!foo/bar']]
  ]
  invalid: [
    code: 'require("fs")'
    options: ['fs']
    errors: [
      message: "'fs' module is restricted from being used."
      type: 'CallExpression'
    ]
  ,
    code: 'require("os ")'
    options: ['fs', 'crypto ', 'stream', 'os']
    errors: [
      message: "'os' module is restricted from being used."
      type: 'CallExpression'
    ]
  ,
    code: 'require("foo/bar")'
    options: ['foo/bar']
    errors: [
      message: "'foo/bar' module is restricted from being used."
      type: 'CallExpression'
    ]
  ,
    code: 'withPaths = require("foo/bar")'
    options: [paths: ['foo/bar']]
    errors: [
      message: "'foo/bar' module is restricted from being used."
      type: 'CallExpression'
    ]
  ,
    code: 'withPatterns = require("foo/bar")'
    options: [patterns: ['foo/*']]
    errors: [
      message: "'foo/bar' module is restricted from being used by a pattern."
      type: 'CallExpression'
    ]
  ,
    code: 'withPatternsAndPaths = require("foo/bar")'
    options: [patterns: ['foo/*'], paths: ['foo']]
    errors: [
      message: "'foo/bar' module is restricted from being used by a pattern."
      type: 'CallExpression'
    ]
  ,
    code: 'withGitignores = require("foo/bar")'
    options: [patterns: ['foo/*', '!foo/baz'], paths: ['foo']]
    errors: [
      message: "'foo/bar' module is restricted from being used by a pattern."
      type: 'CallExpression'
    ]
  ,
    code: 'withGitignores = require("foo")'
    options: [
      name: 'foo'
      message: "Please use 'bar' module instead."
    ]
    errors: [
      message:
        "'foo' module is restricted from being used. Please use 'bar' module instead."
      type: 'CallExpression'
    ]
  ,
    code: 'withGitignores = require("bar")'
    options: [
      'foo'
    ,
      name: 'bar'
      message: "Please use 'baz' module instead."
    ,
      'baz'
    ]
    errors: [
      message:
        "'bar' module is restricted from being used. Please use 'baz' module instead."
      type: 'CallExpression'
    ]
  ,
    code: 'withGitignores = require("foo")'
    options: [
      paths: [
        name: 'foo'
        message: "Please use 'bar' module instead."
      ]
    ]
    errors: [
      message:
        "'foo' module is restricted from being used. Please use 'bar' module instead."
      type: 'CallExpression'
    ]
  ]
