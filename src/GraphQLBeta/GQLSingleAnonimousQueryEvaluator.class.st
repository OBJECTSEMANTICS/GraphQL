"
I represent a evaluator of the graphql query single.

Public API and Key Messages

- argument
- arguments
- booleanValue
- document
- enumValue
- field
- floatValue
- intValue
- listValue
- nullValue
- objectField
- objectValue
- selection
- selectionSet
- stringValue
- variable

"
Class {
	#name : #GQLSingleAnonimousQueryEvaluator,
	#superclass : #GQLSingleAnonimousQueryGrammar,
	#category : #'GraphQLBeta-Parser'
}

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> alias [
"Return the alias"
	^ super alias performs: [ :tokens | (tokens at: 1) inputValue ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> argument [
	"Return an instance of GQLArgumentNode with  information about the query"

	^ super argument
		performs: [ :tokens | 
			| node |
			node := GQLArgumentNode new.
			node name: (tokens at: 1) inputValue.
			node value: (tokens at: 3).
			node position: (tokens at: 1) start.
			node ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> arguments [
	"Return the arguments parsed"

	^ super arguments
		performs: [ :tokens | tokens at: 2 ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> booleanType [
	"Return a GQLSBooleanType instance"

	^ super booleanType
		performs: [ :tokens | 
			| node |
			node := GQLSBooleanTypeNode new.
			node position: tokens start.
			node ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> booleanValue [
"Return GQLBooleanNode instances with the information of the query"
	^ super booleanValue
		performs: [ :tokens | 
			| node |
			node := GQLBooleanNode new.
			node value: tokens inputValue.
			node position: tokens start. ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> comment [
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
GQLSingleAnonimousQueryEvaluator >> comments [
	"Return a [GQLComment]"

	^ super comments
		performs: [ :tokens | tokens ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> defaultValue [
"Return the default value"
	^ super defaultValue
		performs: [ :tokens | (tokens at: 2) ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> directive [
"Return the directive"
	^ super directive performs: [ :tokens | 
		| node |
		node := GQLDirectiveNode new: (tokens at: 2) inputValue.
		node name: (tokens at: 2) inputValue.
		node arguments: (tokens at: 3).
		node position: (tokens at: 2) start.
		node addComments: (Array with: (tokens at: 4)).
		]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> document [
	"Return a instance of GQLDocumentNode with the information of the parser"

	^ super document
		performs: [ :tokens | 
			| node |
			node := GQLDocumentNode new.
			node definitions: tokens ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> enumValue [
	"Return GQLEnumNode instance with the information of the request parsed"

	^ super enumValue
		performs: [ :tokens | 
			| node |
			node := GQLEnumNode new.
			node
				value: tokens inputValue.
			node position: tokens start. ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> floatType [
	"Return a GQLSFloatTypeNode instance"

	^ super floatType
		performs: [ :tokens | 
			| node |
			node := GQLSFloatTypeNode new.
			node ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> floatValue [
	"Return GQLFloatNode instance of input type float with the information of the request parsed"

	^ super floatValue
		performs: [ :tokens | 
			| node |
			node := GQLFloatNode new.
			node value: tokens inputValue.
			node position: tokens start. ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> fragmentDefinition [
	"Return a instance of GQLFragmentNode with the information of the request"

	^ super fragmentDefinition
		performs: [ :tokens | 
			| node |
			node := GQLFragmentNode new
			 	name: (tokens at: 4) inputValue;
				typeCondition: (tokens at: 5);
				directives: (tokens at: 6);
				selectionSet: (tokens at: 7);
				position: (tokens at: 4) start;
				addComments: (tokens atAll: #(1 8)).
			node]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> fragmentName [
"Return the fragmentName"
	^ super fragmentName
		performs: [ :tokens | tokens at: 2 ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> fragmentSpread [
	"Return a instance of GQLFragmentSpreadNode with the information of the request"

	^ super fragmentSpread
		performs: [ :tokens | 
			| node |
			node := GQLFragmentSpreadNode new
				name: (tokens at: 3) inputValue;
				directives: (tokens at: 4);
				position: (tokens at: 3) start;
				addComments: (tokens atAll: #(1 5)).
			node]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> idType [
	"Return a GQLSIDType instance"

	^ super idType
		performs: [ :tokens | 
			| node |
			node := GQLSIDTypeNode new.
			node position: tokens start.
			node ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> inlineFragment [
	"Return a instance of GQLInlineFragmentNode with the information of the request"

	^ super inlineFragment
		performs: [ :tokens | 
			| node |
			node := GQLInlineFragmentNode new
				position: (tokens at: 2) start;
				typeCondition: (tokens at: 3);
				directives: (tokens at: 4);
				selectionSet: (tokens at: 5);
				addComments: (tokens atAll: #(1 6)).
			node]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> intType [
	"Return a GQLSIntTypeNode instance"

	^ super intType
		performs: [ :tokens | 
			| node |
			node := GQLSIntTypeNode new.
			node position: tokens start.
			node ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> intValue [
"Return GQLIntNode instance of input type Int with the information of the request parsed"
	^ super intValue
		performs: [ :tokens | 
			| node |
			node := GQLIntNode new.
			node value: tokens inputValue.
			node position: tokens start. ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> listType [
"Return a list type"
	^ super listType
		performs: [ :tokens | 
			| node |
			node := GQLSListTypeNode new.
			node wrappedType: (tokens at: 2).
			node position: (tokens at: 2) position.
			node ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> listValue [
"Return GQLListNode instance of input type List with the information of the request parsed"
	^ super listValue
		performs: [ :tokens | 
			| node |
			node := GQLListNode new.
			node value: (tokens at: 2).
			node ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> named [
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
GQLSingleAnonimousQueryEvaluator >> nonNullType [
"Return the non null type"
	^ super nonNullType
		performs: [ :tokens | 
			| node |
			node := GQLSNonNullTypeNode new.
			node wrappedType: (tokens at: 1).
			node position: (tokens at: 1) position.
			node ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> nonScalarField [
"Return a GQLNonScalarNode instance with the information of the request parsed"
	^ super nonScalarField
		performs: [ :tokens | 
			| node |
			node := GQLNonScalarFieldNode new.
			node alias: (tokens at: 2).
			node name: (tokens at: 3) inputValue.
			node arguments: (tokens at: 4).
			node directives: (tokens at: 5).
			node selectionSet: (tokens at: 6).
			node position: (tokens at: 3) start.
			node addComments: (tokens atAll: #(1 7)).
			node ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> nullValue [
"Return GQLNullNode instance of input type null with the information of the request parsed"
	^ super nullValue
		performs: [ :tokens | 
			| node |
			node := GQLNullNode new.
			node value: tokens inputValue.
			node position: tokens start.]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> objectField [
	"Return GQLObjectFieldNode instance with the information of the request parsed"

	^ super objectField
		performs: [ :tokens | 
			| node |
			node := GQLObjectFieldNode new.
			node name: (tokens at: 1) inputValue.
			node position: (tokens at: 1) start.
			node value: (tokens at: 3) ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> objectValue [
	"Return GQLObjectNode instance of input type Object with the information of the request parsed"

	^ super objectValue
		performs: [ :tokens | 
			| node |
			node := GQLObjectNode new.
			node objectFields: (tokens at: 2).
			node ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> operation [
	"Return a instance of GQLOperationNode"

	^ super operation
		performs: [ :tokens | 
			| node |
			node := GQLOperationNode new
				type: (tokens at: 2);
				name: (tokens at: 4);
				variableDefinitions: (tokens at: 5);
				directives: (tokens at: 6);
				selectionSet: (tokens at: 7);
				position: (tokens at: 4) start;
				addComments: (tokens atAll: #(1 8)).
			node ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> scalarField [
"Return a GQLScalarFieldNode instance with the information of the request parsed"
	^ super scalarField
		performs: [ :tokens | 
			| node |
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
GQLSingleAnonimousQueryEvaluator >> schemaField [
"Return a GQLNonScalarNode instance with the information of the request parsed"
	^ super schemaField
		performs: [ :tokens | 
			| node |
			node := GQLSchemaFieldNode new.
			node alias: (tokens at: 2).
			node name: (tokens at: 3) inputValue.
			node directives: (tokens at: 4).
			node selectionSet: (tokens at: 5).
			node position: (tokens at: 3) start.
			node addComments: (tokens atAll: #(1 6)).
			node ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> selection [
"Return the tokens parsed"
	^ super selection performs: [ :tokens | tokens ]
]

{ #category : #grammar }
GQLSingleAnonimousQueryEvaluator >> selectionSet [
"Return a instance of GQLSelectionSetNode with the information of the parser"

	^ super selectionSet
		performs: [ :tokens | 
			| node val |
			val := tokens at: 3.
			node := GQLSelectionSetNode new.
			node
				selections: val;
				position: (tokens at: 2) start;
				addComments: (tokens atAll: #(1 5)) ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> stringType [
	"Return a GQLSStringType instance"

	^ super stringType
		performs: [ :tokens | 
			| node |
			node := GQLSStringTypeNode new.
			node position: tokens start.
			node ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> stringValue [
"Return GQLStringNode instance of input type String with the information of the request parsed"
	^ super stringValue
		performs: [ :tokens | 
			| node |
			node := GQLStringNode new.
			node value: tokens inputValue.
			node position: tokens start. ]
]

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> typeCondition [
"Return the type condition"
	^ super typeCondition
		performs: [ :tokens | (tokens at: 3) ]
]

{ #category : #grammar }
GQLSingleAnonimousQueryEvaluator >> typeField [
"Return a GQLNonScalarNode instance with the information of the request parsed"
	^ super typeField
		performs: [ :tokens | 
			| node |
			node := GQLTypeFieldNode new.
			node alias: (tokens at: 2).
			node name: (tokens at: 3) inputValue.
			node arguments: (tokens at: 4).
			node directives: (tokens at: 5).
			node selectionSet: (tokens at: 6).
			node position: (tokens at: 3) start.
			node addComments: (tokens atAll: #(1 7)).
			node ]
]

{ #category : #grammar }
GQLSingleAnonimousQueryEvaluator >> typenameField [
"Return a GQLNonScalarNode instance with the information of the request parsed"
	^ super typenameField
		performs: [ :tokens | 
			| node |
			node := GQLTypenameFieldNode new.
			node alias: (tokens at: 2).
			node name: (tokens at: 3) inputValue.
			node directives: (tokens at: 4).
			node position: (tokens at: 3) start.
			node addComments: (tokens atAll: #(1 5)).
			node ]
]

{ #category : #grammar }
GQLSingleAnonimousQueryEvaluator >> variable [
"Return GQLVariableNode instance of input type variable with the information of the request parsed"
	^ super variable
		performs: [ :tokens | 
			GQLVariableNode new
				value: (tokens inputValue copyWithout: $$);
				position: tokens start
			]
]

{ #category : #grammar }
GQLSingleAnonimousQueryEvaluator >> variableDefinition [
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

{ #category : #accessing }
GQLSingleAnonimousQueryEvaluator >> variableDefinitions [
	"Return the variable definitions"

	^ super variableDefinitions
		performs:
			[ :tokens | (tokens at: 2) reject: [ :var | var isCharacter ] ]
]
