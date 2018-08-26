// Generated by CoffeeScript 2.3.1
(function() {
  /**
   * @fileoverview Rule to enforce concise object methods and properties.
   * @author Jamund Ferguson
   */
  'use strict';
  var OPTIONS, astUtils;

  OPTIONS = {
    always: 'always',
    never: 'never',
    consistent: 'consistent',
    consistentAsNeeded: 'consistent-as-needed'
  };

  //------------------------------------------------------------------------------
  // Requirements
  //------------------------------------------------------------------------------
  astUtils = require('eslint/lib/ast-utils');

  //------------------------------------------------------------------------------
  // Rule Definition
  //------------------------------------------------------------------------------
  module.exports = {
    meta: {
      docs: {
        description: 'require or disallow property shorthand syntax for object literals',
        category: 'ECMAScript 6',
        recommended: false,
        url: 'https://eslint.org/docs/rules/object-shorthand'
      },
      schema: {
        anyOf: [
          {
            type: 'array',
            items: [
              {
                enum: ['always',
              'never',
              'consistent',
              'consistent-as-needed']
              }
            ],
            minItems: 0,
            maxItems: 1
          }
        ]
      }
    },
    create: function(context) {
      /**
       * Ensures that an object's properties are consistently shorthand, or not shorthand at all.
       * @param   {ASTNode} node Property AST node
       * @param   {boolean} checkRedundancy Whether to check longform redundancy
       * @returns {void}
       *
       */
      /**
       * Determines if the property's key and method or value are named equally.
       * @param {ASTNode} property Property AST node
       * @returns {boolean} True if the key and value are named equally, false if not.
       * @private
       *
       */
      /**
       * Determines if the property is a shorthand or not.
       * @param {ASTNode} property Property AST node
       * @returns {boolean} True if the property is considered shorthand, false if not.
       * @private
       *
       */
      var APPLY, APPLY_CONSISTENT, APPLY_CONSISTENT_AS_NEEDED, APPLY_NEVER, APPLY_PROPERTIES, canHaveShorthand, checkConsistency, isRedundant, isShorthand;
      APPLY = context.options[0];
      APPLY_NEVER = APPLY === OPTIONS.never;
      APPLY_CONSISTENT = APPLY === OPTIONS.consistent;
      APPLY_CONSISTENT_AS_NEEDED = APPLY === OPTIONS.consistentAsNeeded;
      APPLY_PROPERTIES = !APPLY || APPLY === OPTIONS.always;
      //--------------------------------------------------------------------------
      // Helpers
      //--------------------------------------------------------------------------
      /**
       * Determines if the property can have a shorthand form.
       * @param {ASTNode} property Property AST node
       * @returns {boolean} True if the property can have a shorthand form
       * @private
       *
       */
      canHaveShorthand = function(property) {
        return property.kind !== 'set' && property.kind !== 'get' && property.type !== 'SpreadElement';
      };
      isShorthand = function(property) {
        return property.shorthand;
      };
      isRedundant = function(property) {
        var value;
        ({value} = property);
        if (value.type !== 'Identifier') {
          return false;
        }
        return astUtils.getStaticPropertyName(property) === value.name;
      };
      checkConsistency = function(node, checkRedundancy) {
        /*
         * If all properties of the object contain a method or value with a name matching it's key,
         * all the keys are redundant.
         */
        var canAlwaysUseShorthand, properties, shorthandProperties;
        // We are excluding getters/setters and spread properties as they are considered neither longform nor shorthand.
        properties = node.properties.filter(canHaveShorthand);
        // Do we still have properties left after filtering the getters and setters?
        if (properties.length > 0) {
          shorthandProperties = properties.filter(isShorthand);
          /*
           * If we do not have an equal number of longform properties as
           * shorthand properties, we are using the annotations inconsistently
           */
          if (shorthandProperties.length !== properties.length) {
            // We have at least 1 shorthand property
            if (shorthandProperties.length > 0) {
              return context.report({
                node,
                message: 'Unexpected mix of shorthand and non-shorthand properties.'
              });
            } else if (checkRedundancy) {
              canAlwaysUseShorthand = properties.every(isRedundant);
              if (canAlwaysUseShorthand) {
                return context.report({
                  node,
                  message: 'Expected shorthand for all properties.'
                });
              }
            }
          }
        }
      };
      return {
        //--------------------------------------------------------------------------
        // Public
        //--------------------------------------------------------------------------
        ObjectExpression: function(node) {
          if (APPLY_CONSISTENT) {
            return checkConsistency(node, false);
          } else if (APPLY_CONSISTENT_AS_NEEDED) {
            return checkConsistency(node, true);
          }
        },
        'Property:exit': function(node) {
          var isConciseProperty, ref;
          isConciseProperty = node.shorthand;
          // Ignore destructuring assignment
          if (node.parent.type === 'ObjectPattern') {
            return;
          }
          // getters and setters are ignored
          if ((ref = node.kind) === 'get' || ref === 'set') {
            return;
          }
          // only computed methods can fail the following checks
          if (node.computed) {
            return;
          }
          //--------------------------------------------------------------
          // Checks for property/method shorthand.
          if (isConciseProperty) {
            if (APPLY_NEVER) {
              // { x } should be written as { x: x }
              return context.report({
                node,
                message: 'Expected longform property syntax.'
              });
            }
          } else if (node.value.type === 'Identifier' && node.key.name === node.value.name && APPLY_PROPERTIES) {
            // {x: x} should be written as {x}
            return context.report({
              node,
              message: 'Expected property shorthand.'
            });
          } else if (node.value.type === 'Identifier' && node.key.type === 'Literal' && node.key.value === node.value.name && APPLY_PROPERTIES) {
            // {"x": x} should be written as {x}
            return context.report({
              node,
              message: 'Expected property shorthand.'
            });
          }
        }
      };
    }
  };

}).call(this);