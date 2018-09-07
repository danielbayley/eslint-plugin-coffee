// Generated by CoffeeScript 2.3.1
(function() {
  /**
   * @fileoverview Rule to enforce var declarations are only at the top of a function.
   * @author Danny Fritz
   * @author Gyandeep Singh
   */
  'use strict';
  var boundaryNodeRegex;

  boundaryNodeRegex = /Function/;

  //------------------------------------------------------------------------------
  // Rule Definition
  //------------------------------------------------------------------------------
  module.exports = {
    meta: {
      docs: {
        description: 'require `var` declarations be placed at the top of their containing scope',
        category: 'Best Practices',
        recommended: false,
        url: 'https://eslint.org/docs/rules/vars-on-top'
      },
      schema: []
    },
    create: function(context) {
      /**
       * Checks whether variable is on top at functional block scope level
       * @param {ASTNode} node - The node to check
       * @param {ASTNode} parent - Parent of the node
       * @param {ASTNode} grandParent - Parent of the node's parent
       * @returns {void}
       */
      /**
       * Checks whether variable is on top at the global level
       * @param {ASTNode} node - The node to check
       * @param {ASTNode} parent - Parent of the node
       * @returns {void}
       */
      /**
       * Checks whether this variable is on top of the block body
       * @param {ASTNode} node - The node to check
       * @param {ASTNode[]} statements - collection of ASTNodes for the parent node block
       * @returns {boolean} True if var is on top otherwise false
       */
      /**
       * Checks whether a given node is a variable declaration or not.
       *
       * @param {ASTNode} node - any node
       * @returns {boolean} `true` if the node is a variable declaration.
       */
      /**
       * Check to see if its a ES6 import declaration
       * @param {ASTNode} node - any node
       * @returns {boolean} whether the given node represents a import declaration
       */
      var blockScopeVarCheck, containsDeclaration, errorMessage, findEnclosingAssignment, findEnclosingExpressionStatement, globalVarCheck, isDeclarationAssignment, isVarOnTop, isVariableDeclaration, looksLikeDirective, looksLikeImport;
      errorMessage = 'All declarations must be at the top of the function scope.';
      //--------------------------------------------------------------------------
      // Helpers
      //--------------------------------------------------------------------------
      /**
       * @param {ASTNode} node - any node
       * @returns {boolean} whether the given node structurally represents a directive
       */
      looksLikeDirective = function(node) {
        return node.type === 'ExpressionStatement' && node.expression.type === 'Literal' && typeof node.expression.value === 'string';
      };
      looksLikeImport = function(node) {
        var ref;
        return (ref = node.type) === 'ImportDeclaration' || ref === 'ImportSpecifier' || ref === 'ImportDefaultSpecifier' || ref === 'ImportNamespaceSpecifier';
      };
      containsDeclaration = function(node) {
        var element, j, k, len, len1, prop, ref, ref1;
        switch (node.type) {
          case 'Identifier':
            return node.declaration;
          case 'ObjectPattern':
            ref = node.properties;
            for (j = 0, len = ref.length; j < len; j++) {
              prop = ref[j];
              if (containsDeclaration(prop)) {
                return true;
              }
            }
            return false;
          case 'Property':
            return containsDeclaration(node.value);
          case 'RestElement':
            return containsDeclaration(node.argument);
          case 'ArrayPattern':
            ref1 = node.elements;
            for (k = 0, len1 = ref1.length; k < len1; k++) {
              element = ref1[k];
              if (containsDeclaration(element)) {
                return true;
              }
            }
            return false;
          case 'AssignmentPattern':
            return containsDeclaration(node.left);
        }
      };
      isDeclarationAssignment = function(node) {
        if ((node != null ? node.type : void 0) !== 'AssignmentExpression') {
          return false;
        }
        return containsDeclaration(node.left);
      };
      isVariableDeclaration = function(node) {
        return (node.type === 'ExpressionStatement' && isDeclarationAssignment(node.expression)) || (node.type === 'ExportNamedDeclaration' && isDeclarationAssignment(node.declaration));
      };
      isVarOnTop = function(node, statements) {
        var i, l;
        l = statements.length;
        i = 0;
        // skip over directives
        while (i < l) {
          if (!looksLikeDirective(statements[i]) && !looksLikeImport(statements[i])) {
            break;
          }
          ++i;
        }
        while (i < l) {
          if (!isVariableDeclaration(statements[i])) {
            return false;
          }
          if (statements[i] === node) {
            return true;
          }
          ++i;
        }
        return false;
      };
      globalVarCheck = function(node, assignment, parent) {
        if (!isVarOnTop(assignment, parent.body)) {
          return context.report({
            node,
            message: errorMessage
          });
        }
      };
      blockScopeVarCheck = function(node, assignment, parent, grandParent) {
        if (!((assignment != null) && /Function/.test(grandParent.type) && parent.type === 'BlockStatement' && isVarOnTop(assignment, parent.body))) {
          return context.report({
            node,
            message: errorMessage
          });
        }
      };
      findEnclosingAssignment = function(node) {
        var currentNode, prevNode;
        currentNode = node;
        prevNode = null;
        while (currentNode) {
          if (boundaryNodeRegex.test(node.type)) {
            return;
          }
          if (currentNode.type === 'Property' && prevNode === currentNode.key && prevNode !== currentNode.value) {
            return;
          }
          if (currentNode.type === 'AssignmentExpression') {
            if (prevNode === currentNode.left) {
              return currentNode;
            }
            return;
          }
          prevNode = currentNode;
          currentNode = currentNode.parent;
        }
      };
      findEnclosingExpressionStatement = function(assignmentNode) {
        var currentNode;
        currentNode = assignmentNode;
        while (currentNode.type === 'AssignmentExpression') {
          currentNode = currentNode.parent;
        }
        if (currentNode.type === 'ExpressionStatement') {
          return currentNode;
        }
      };
      return {
        //--------------------------------------------------------------------------
        // Public API
        //--------------------------------------------------------------------------
        'Identifier[declaration=true]': function(node) {
          var enclosingAssignment, enclosingExpressionStatement;
          enclosingAssignment = findEnclosingAssignment(node);
          if (!enclosingAssignment) {
            return;
          }
          enclosingExpressionStatement = findEnclosingExpressionStatement(enclosingAssignment);
          if (enclosingAssignment.parent.type === 'ExportNamedDeclaration') {
            return globalVarCheck(node, enclosingAssignment.parent, enclosingAssignment.parent.parent);
          } else if ((enclosingExpressionStatement != null ? enclosingExpressionStatement.parent.type : void 0) === 'Program') {
            return globalVarCheck(node, enclosingExpressionStatement, enclosingExpressionStatement.parent);
          } else {
            return blockScopeVarCheck(node, enclosingExpressionStatement, enclosingExpressionStatement != null ? enclosingExpressionStatement.parent : void 0, enclosingExpressionStatement != null ? enclosingExpressionStatement.parent.parent : void 0);
          }
        }
      };
    }
  };

}).call(this);