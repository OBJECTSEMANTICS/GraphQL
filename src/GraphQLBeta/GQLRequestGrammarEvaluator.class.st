"
I represent a evaluator of the graphql request.
"
Class {
	#name : #GQLRequestGrammarEvaluator,
	#superclass : #GQLRequestGrammar,
	#category : #'GraphQLBeta-Parser'
}

{ #category : #grammar }
GQLRequestGrammarEvaluator >> alias [
"Return the alias"
	^ super alias
		performs: [ :tokens | (tokens at: 1) inputValue ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> argument [
"Return a GQLArgumentNode instance with the information parsed of the request"
	^ super argument
		performs: [ :tokens | 
			|node|
			node := GQLArgumentNode new.
			node name: (tokens at: 1) inputValue.
			node value: (tokens at: 3).
			node position: (tokens at: 1) start.
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> arguments [
"Return the arguments"
	^ super arguments
		performs: [ :tokens | tokens at: 2 ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> booleanType [
	"Return a GQLSBooleanType instance"

	^ super booleanType
		performs: [ :tokens | 
			| node |
			node := GQLSBooleanTypeNode new.
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> booleanValue [
"Return the boolean value"
	^ super booleanValue
		performs: [ :tokens | 
			| node |
			node := GQLBooleanNode new.
			node 
				value: tokens inputValue;
				position: tokens start.
			node ]
]

{ #category : #accessing }
GQLRequestGrammarEvaluator >> comment [
	"Return a GQLComment instance"

	^ super comment
		performs: [ :tokens | 
			| node |
			node := GQLComment new.
			node value: (tokens inputValue) trim.
			node position: tokens start.
			node ]
]

{ #category : #accessing }
GQLRequestGrammarEvaluator >> comments [
	"Return a [GQLComment]"

	^ super comments
		performs: [ :tokens | tokens ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> defaultValue [
"Return the default value"
	^ super defaultValue
		performs: [ :tokens | (tokens at: 2) ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> directive [
"Return a GQLDirectiveNode instance with the information of the request"
	^ super directive
		performs: [ :tokens | 
			|node|
			node := GQLDirectiveNode new.
			node name: (tokens at: 2) inputValue.
			node arguments: (tokens at: 3).
			node addComments: (Array with: (tokens at: 4)).
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> document [
	"Return a instance of GQLDocumentNode with the information of the parser"

	^ super document
		performs: [ :tokens | 
			| node |
			node := GQLDocumentNode new.
			node definitions: tokens
		]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> enumValue [
"Return the enum value"
	^ super enumValue
		performs: [ :tokens | 
			| node |
			node := GQLEnumNode new.
			node 
				value: tokens inputValue;
				position: tokens start.
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> floatType [
	"Return a GQLSFloatTypeNode instance"

	^ super floatType
		performs: [ :tokens | 
			| node |
			node := GQLSFloatTypeNode new.
			node position: tokens start.
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> floatValue [
"Return the variable"
	^ super floatValue
		performs: [ :tokens | 
			| node |
			node := GQLFloatNode new.
			node
				value: tokens inputValue;
				position: tokens start.
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> fragmentDefinition [
	"Return a instance of GQLFragmentNode with the information of the request"

	^ super fragmentDefinition
		performs: [ :tokens | 
			| node |
			node := GQLFragmentNode new.
			node name: (tokens at: 4) inputValue.
			node typeCondition: (tokens at: 5).
			node directives: (tokens at: 6).
			node selectionSet: (tokens at: 7).
			node position: (tokens at: 4) start.
			node addComments: (tokens atAll: #(1 8)).
			node]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> fragmentName [
"Return the fragmentName"
	^ super fragmentName
		performs: [ :tokens | (tokens at: 2) ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> fragmentSpread [
	"Return a instance of GQLFragmentSpreadNode with the information of the request"

	^ super fragmentSpread
		performs: [ :tokens | 
			| node |
			node := GQLFragmentSpreadNode new.
			node name: (tokens at: 3) inputValue.
			node directives: (tokens at: 4).
			node position: (tokens at: 3) start.
			node addComments: (tokens atAll: #(1 5)).
			node]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> idType [
	"Return a GQLSIDType instance"

	^ super idType
		performs: [ :tokens | 
			| node |
			node := GQLSIDTypeNode new.
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> inlineFragment [
	"Return a instance of GQLInlineFragmentNode with the information of the request"

	^ super inlineFragment
		performs: [ :tokens | 
			| node |
			node := GQLInlineFragmentNode new
				typeCondition: (tokens at: 3);
				directives: (tokens at: 4);
				selectionSet: (tokens at: 5);
				addComments: (tokens atAll: #(1 6)).
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> intType [
	"Return a GQLSIntTypeNode instance"

	^ super intType
		performs: [ :tokens | 
			| node |
			node := GQLSIntTypeNode new.
			node position: tokens start.
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> intValue [
"Return the intValue"
	^ super intValue
		performs: [ :tokens | 
			| node |
			node := GQLIntNode new.
			node 
				value: tokens inputValue;
				position: tokens start.
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> listType [
"Return a list type"
	^ super listType
		performs: [ :tokens | 
			| node |
			node := GQLSListTypeNode new.
			node wrappedType: (tokens at: 2).
			node position: (tokens at: 2) position.
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> listValue [
"Return the list value"
	^ super listValue
		performs: [ :tokens | 
			| node |
			node := GQLListNode new.
			node position: (tokens at: 1) start.
			node value: (tokens at: 2).
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> named [
	"Return a GQLSNamedTypeNode instance with his name and the position on the request"

	^ super named
		performs: [ :tokens | 
			| node |
			node := GQLSNamedTypeNode new.
			node name: tokens inputValue.
			node position: tokens start.
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> nonNullType [
"Return the non null type"
	^ super nonNullType
		performs: [ :tokens | 
			| node |
			node := GQLSNonNullTypeNode new.
			node wrappedType: (tokens at: 1).
			node position: (tokens at: 1) position.
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> nonScalarField [
"Return a GQLNonScalarNode instance with the information of the request parsed"
	^ super nonScalarField
		performs: [ :tokens | 
			| node |
			node := GQLNonScalarFieldNode new.
			node alias: (tokens at: 2).
			node name: (tokens at: 3) inputValue.
			node arguments: (tokens at: 4).
			node selectionSet: (tokens at: 6).
			node position: (tokens at: 3) start.
			node addComments: (tokens atAll: #(1 7)).
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> nullValue [
"Return the nullValue"
	^ super nullValue
		performs: [ :tokens | 
			| node |
			node := GQLNullNode new.
			node
				value: tokens inputValue;
				position: tokens start.
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> objectField [
"Return a GQLObjectFieldNode instance with the information from the request"
	^ super objectField
		performs: [ :tokens | 
			| node |
			node := GQLObjectFieldNode new.
			node name: (tokens at: 1) inputValue.
			node position: (tokens at: 1) start.
			node value: (tokens at: 3).
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> objectValue [
"Return the objectValue"
	^ super objectValue
		performs: [ :tokens | 
			| node |
			node := GQLObjectNode new.
			node objectFields: (tokens at: 2).
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> operation [
	"Return a instance of GQLOperationNode with the information of the parser"

	^ super operation
		performs: [ :tokens | 
			| node |
			node := GQLOperationNode new.
			node type: (tokens at: 2).
			node name: (tokens at: 4).
			node variableDefinitions: (tokens at: 5).
			node directives: (tokens at: 6).
			node selectionSet: (tokens at: 7).
			node addComments: (tokens atAll: #(1 8))]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> scalarField [
"Return a GQLScalarFieldNode instance with the information from the request"
	^ super scalarField
		performs: [ :tokens | 
			|node|
			node := GQLScalarFieldNode new.
			node alias: (tokens at: 2).
			node name: (tokens at: 3) inputValue.
			node arguments: (tokens at: 4).
			node directives: (tokens at: 5).
			node position: (tokens at: 3) start.
			node addComments: (tokens atAll: #(1 6)).
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> selectionSet [
"Return a set of selections"
	^ super selectionSet
		performs: [ :tokens | 
			|node|
			node := GQLSelectionSetNode new.
			node selections: (tokens at: 3).
			node addComments: (tokens atAll: #(1 5)).
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> stringType [
	"Return a GQLSStringType instance"

	^ super stringType
		performs: [ :tokens | 
			| node |
			node := GQLSStringTypeNode new.
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> stringValue [
"Return the string value"
	^ super stringValue
		performs: [ :tokens | 
			| node |
			node := GQLStringNode new.
			node 
				value: tokens inputValue;
				position: tokens start.
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> typeCondition [
"Return the type condition"
	^ super typeCondition
		performs: [ :tokens | (tokens at: 3) ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> variable [
"Return a GQLVariableNode instance with the value assigned"
	^ super variable
		performs: [ :tokens | 
			GQLVariableNode new
				value: (tokens inputValue copyWithout: $$);
				position: tokens start ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> variableDefinition [
"Return a GQLVariableDefinitionNode instance with the name, type and the default value of the variable"
	^ super variableDefinition
		performs: [ :tokens |
			| node |
			node := GQLVariableDefinitionNode new.
			node name: (tokens at: 1) value.
			node position: (tokens at: 1) position.
			node type: (tokens at: 3).
			node defaultValue: (tokens at: 4).
			node ]
]

{ #category : #grammar }
GQLRequestGrammarEvaluator >> variableDefinitions [
"Return the variable definitions"
	^ super variableDefinitions
		performs: [ :tokens | (tokens at: 2) reject: [ :var | var isCharacter ] ]
]
