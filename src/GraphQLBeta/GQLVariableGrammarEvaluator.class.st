"
I represent a evaluator of variables assignments

Public API and Key Messages

- variableSet
- variableValue
- tokenValue
"
Class {
	#name : #GQLVariableGrammarEvaluator,
	#superclass : #GQLVariableGrammar,
	#category : #'GraphQLBeta-Parser'
}

{ #category : #accessing }
GQLVariableGrammarEvaluator >> booleanValue [
"Return the boolean value"
	^ super booleanValue
		performs: [ :tokens | 
			| node |
			node := GQLBooleanNode new.
			node value: tokens inputValue.
			node ]
]

{ #category : #accessing }
GQLVariableGrammarEvaluator >> enumValue [
"Return the enum value"
	^ super enumValue
		performs: [ :tokens | 
			| node |
			node := GQLEnumNode new.
			node value: tokens inputValue.
			node ]
]

{ #category : #accessing }
GQLVariableGrammarEvaluator >> floatValue [
"Return the variable"
	^ super floatValue
		performs: [ :tokens | 
			| node |
			node := GQLFloatNode new.
			node value: tokens inputValue.
			node ]
]

{ #category : #accessing }
GQLVariableGrammarEvaluator >> intValue [
"Return the intValue"
	^ super intValue
		performs: [ :tokens | 
			| node |
			node := GQLIntNode new.
			node value: tokens inputValue.
			node ]
]

{ #category : #accessing }
GQLVariableGrammarEvaluator >> listValue [
"Return the list value"
	^ super listValue
		performs: [ :tokens | 
			| node |
			node := GQLListNode new.
			node value: (tokens at: 2).
			node ]
]

{ #category : #accessing }
GQLVariableGrammarEvaluator >> nullValue [
"Return the nullValue"
	^ super nullValue
		performs: [ :tokens | 
			| node |
			node := GQLNullNode new.
			node value: tokens inputValue.
			node ]
]

{ #category : #accessing }
GQLVariableGrammarEvaluator >> objectField [
"Return a GQLObjectFieldNode instance with the information from the request"
	^ super objectField
		performs: [ :tokens | 
			| node |
			node := GQLObjectFieldNode new.
			node name: (tokens at: 1) inputValue.
			node value: (tokens at: 3).
			node ]
]

{ #category : #accessing }
GQLVariableGrammarEvaluator >> objectValue [
"Return the objectValue"
	^ super objectValue
		performs: [ :tokens | 
			| node |
			node := GQLObjectNode new.
			node objectFields: (tokens at: 2).
			node ]
]

{ #category : #accessing }
GQLVariableGrammarEvaluator >> stringValue [
"Return the string value"
	^ super stringValue
		performs: [ :tokens | 
			| node |
			node := GQLStringNode new.
			node value: tokens inputValue.
			node ]
]

{ #category : #accessing }
GQLVariableGrammarEvaluator >> variableSet [
"Return the variableValues parsed"

	^ super variableSet
		performs: [ :tokens | tokens at: 2 ]
]

{ #category : #grammar }
GQLVariableGrammarEvaluator >> variableValue [
"Return a instance of GQLVariableDefinitionNode with the information of the parser"

	^ super variableValue
		performs: [ :tokens | 
			| node |
			node := GQLVariableDefinitionNode new.
			node name: ((tokens at: 1) executeOn: nil with: nil using: nil).
			node value: (tokens at: 3).
			node
		]
]
