###*
# @fileoverview Common utils for AST.
# @author Gyandeep Singh
###

'use strict'

#------------------------------------------------------------------------------
# Public Interface
#------------------------------------------------------------------------------

module.exports =
  ###*
  # Get the precedence level based on the node type
  # @param {ASTNode} node node to evaluate
  # @returns {int} precedence level
  # @private
  ###
  getPrecedence: (node) ->
    switch node.type
      # when 'SequenceExpression'
      #   return 0

      when 'AssignmentExpression' #,           'ArrowFunctionExpression', 'YieldExpression'
        return 1

      # when 'ConditionalExpression'
      #   return 3

      when 'LogicalExpression'
        switch node.operator
          when '||', 'or'
            return 4
          when '&&', 'and'
            return 5

          # no default

      ### falls through ###

      when 'BinaryExpression'
        switch node.operator
          when '?'
            return 3
          when '|'
            return 6
          when '^'
            return 7
          when '&'
            return 8
          when '==', '!=', '===', '!=='
            return 9
          when '<', '<=', '>', '>=', 'in', 'instanceof'
            return 10
          when '<<', '>>', '>>>'
            return 11
          when '+', '-'
            return 12
          when '*', '/', '%'
            return 13
          when '**'
            return 15

          # no default

      ### falls through ###

      # when 'UnaryExpression', 'AwaitExpression'
      #   return 16

      # when 'UpdateExpression'
      #   return 17

      # when 'CallExpression'
      #   return 18

      # when 'NewExpression'
      #   return 19

      # else
      #   return 20