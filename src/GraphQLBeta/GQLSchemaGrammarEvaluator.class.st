"
I represent a evaluator for the schema grammar.

Public API and Key Messages

- field
- fieldSet
- inputType
- listInputType
- listType
- objectType
- parameter
- parameters
- schema
- singleInputType
- singleType
- start
"
Class {
	#name : #GQLSchemaGrammarEvaluator,
	#superclass : #GQLSchemaGrammar,
	#category : #'GraphQLBeta-Parser'
}

{ #category : #accessing }
GQLSchemaGrammarEvaluator >> booleanType [
	"Return a GQLSBooleanType instance"

	^ super booleanType
		performs: [ :tokens | 
			| node |
			node := GQLSBooleanTypeNode new.
			node ]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> comment [
	"Return a GQLComment instance"

	^ super comment
		performs: [ :tokens | 
			| node |
			node := GQLComment new.
			node value: (tokens inputValue) trim.
			node position: tokens start.
			node ]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> comments [
	"Return a [GQLComment]"

	^ super comments
		performs: [ :tokens | tokens ]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> description [
	^ super description 
		performs: [ :tokens | 
			| node |
			node := GQLSDescription new.
			node position: tokens start.
			node value: tokens inputValue.
			node ]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> enumType [
	"Return a GQLSEnumTypeNode instance with the enumTypeName, the values and the position on the text schema"

	^ super enumType
		performs: [ :tokens | 
			| node |
			node := GQLSEnumTypeNode new.
			node description: (tokens at: 2).
			node name: (tokens at: 5) inputValue.
			node addValues: (tokens at: 6) second.
			node position: (tokens at: 5) start.
			node addComments: (tokens atAll: #(1 3 7)) ]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> enumTypeExtension [
	"Return a GQLSEnumTypeNode instance with the enumTypeName, the values and the position on the text schema"

	^ super enumTypeExtension
		performs: [ :tokens | 
			| node |
			node := GQLSEnumTypeNode new.
			node name: (tokens at: 2) inputValue.
			node addValues: (tokens at: 3) second.
			node position: (tokens at: 2) start.
			node addComments: (tokens atAll: #(4)) ]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> enumValue [
	"Return a GQLSEnumTypeNode instance with the enumTypeName, the values and the position on the text schema"

	^ super enumValue
		performs: [ :tokens | 
			| node |
			node := GQLSEnumValue new.
			node description: (tokens at: 2).
			node value: (tokens at: 4) inputValue.
			node position: (tokens at: 4) start.
			node addComments: (tokens atAll: #(1 3 5))
		]
]

{ #category : #accessing }
GQLSchemaGrammarEvaluator >> enumValueList [
	"Return an array"

	^ super enumValueList
		performs: [ :tokens | tokens ]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> field [
	"Return a GQLSFieldNode instance with the name, arguments, type and position on the text schema"

	^ super field
		performs: [ :tokens | 
			| node |
			node := GQLSFieldNode new.
			node description: (tokens at: 2).
			node name: (tokens at: 4) inputValue.
			node addArguments: (tokens at: 5).
			node type: (tokens at: 7).
			node position: (tokens at: 4) start.
			node addComments: (tokens atAll: #(1 3 8)).
			node fullName.
			node ]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> fieldInputObject [
	"Return a GQLSFieldInputObjectFieldNode instance with the name, arguments, type and position on the text schema"

	^ super field
		performs: [ :tokens | 
			| node |
			node := GQLSInputObjectFieldNode new.
			node description: (tokens at: 2).
			node name: (tokens at: 4) inputValue.
			node addArguments: (tokens at: 5).
			node type: (tokens at: 7).
			node position: (tokens at: 4) start.
			node addComments: (tokens atAll: #(1 3 8)).
			node fullName.
			node ]
]

{ #category : #accessing }
GQLSchemaGrammarEvaluator >> fieldInputObjectSet [
"Return the fields"
	^ super fieldInputObjectSet
		performs: [ :tokens | tokens at: 2 ]
]

{ #category : #accessing }
GQLSchemaGrammarEvaluator >> fieldSet [
"Return the fields"
	^ super fieldSet
		performs: [ :tokens | tokens at: 2 ]
]

{ #category : #accessing }
GQLSchemaGrammarEvaluator >> floatType [
	"Return a GQLSFloatType instance"

	^ super floatType
		performs: [ :tokens | 
			| node |
			node := GQLSFloatTypeNode new.
			node ]
]

{ #category : #accessing }
GQLSchemaGrammarEvaluator >> idType [
	"Return a GQLSIDType instance"

	^ super idType
		performs: [ :tokens | 
			| node |
			node := GQLSIDTypeNode new.
			node ]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> inputObjectType [
	"Return a GQLSInputObjectTypeNode instance with the input object name, the fields and the position on the text schema"

	^ super inputObjectType
		performs: [ :tokens | 
			| node |
			node := GQLSInputObjectTypeNode new.
			node description: (tokens at: 2).
			node name: (tokens at: 5) inputValue.
			node addFields: (tokens at: 6).
			node position: (tokens at: 5) start.
			node addComments: (tokens atAll: #(1 3 7)) ]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> inputObjectTypeExtension [
	"Return a GQLSInputObjectTypeNode instance with the input object name, the fields and the position on the text schema"

	^ super inputObjectTypeExtension
		performs: [ :tokens | 
			| node |
			node := GQLSInputObjectTypeNode new.
			node name: (tokens at: 2) inputValue.
			node addFields: (tokens at: 3).
			node position: (tokens at: 2) start.
			node addComments: (tokens atAll: #(4)) ]
]

{ #category : #accessing }
GQLSchemaGrammarEvaluator >> inputType [
"Return the tokens"
	^ super inputType performs: [ :tokens | tokens ]
]

{ #category : #accessing }
GQLSchemaGrammarEvaluator >> intType [
	"Return a GQLSIntType instance"

	^ super intType
		performs: [ :tokens | 
			| node |
			node := GQLSIntTypeNode new.
			node position: tokens start.
			node ]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> interfaceList [
	"Return an array"

	^ super interfaceList
		performs: [ :tokens | 
			(tokens at: 2) reject: #isCharacter thenCollect: #inputValue ]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> interfaceType [
	"Return a GQLSInterfaceTypeNode instance with the enumTypeName, the values and the position on the text schema"

	^ super interfaceType
		performs: [ :tokens | 
			| node |
			node := GQLSInterfaceTypeNode new.
			node description: (tokens at: 2).
			node name: (tokens at: 5) inputValue.
			node addFields: (tokens at: 6).
			node position: (tokens at: 5) start.
			node addComments: (tokens atAll: #(1 3 7)) 
	]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> interfaceTypeExtension [
	"Return a GQLSInterfaceTypeNode instance with the enumTypeName, the values and the position on the text schema"

	^ super interfaceTypeExtension
		performs: [ :tokens | 
			| node |
			node := GQLSInterfaceTypeNode new.
			node name: (tokens at: 2) inputValue.
			node addFields: (tokens at: 3).
			node position: (tokens at: 2) start.
			node addComments: (tokens atAll: #(4)) 
	]
]

{ #category : #accessing }
GQLSchemaGrammarEvaluator >> listInputType [
	"Return a GQLSListTypeNode instance with the innerInputType and if is null"

	^ super listInputType
		performs: [ :tokens | 
			| node |
			node := GQLSListTypeNode new.
			node wrappedType: (tokens at: 2).
			node position: (tokens at: 2) position.
			node ]
]

{ #category : #accessing }
GQLSchemaGrammarEvaluator >> listType [
	"Return a GQLSListTypeNode instance with the innerTypeNode"

	^ super listType
		performs: [ :tokens | 
			| node |
			node := GQLSListTypeNode new.
			node wrappedType: (tokens at: 2).
			node position: (tokens at: 2) position.
			node ]
]

{ #category : #accessing }
GQLSchemaGrammarEvaluator >> namedType [
	"Return a GQLSNamedTypeNode instance with the wrapped type"

	^ super namedType
		performs: [ :tokens | 
			| node |
			node := GQLSNamedTypeNode new.
			node name: tokens inputValue.
			node position: tokens start.
			node ]
]

{ #category : #accessing }
GQLSchemaGrammarEvaluator >> nonNullInputType [
	"Return a GQLSNonNullInputTypeNode instance with the wrapped type"

	^ super nonNullInputType
		performs: [ :tokens | 
			| node |
			node := GQLSNonNullTypeNode new.
			node wrappedType: (tokens at: 1).
			node position: (tokens at: 1) position.
			node ]
]

{ #category : #accessing }
GQLSchemaGrammarEvaluator >> nonNullType [
	"Return a GQLSNonNullTypeNode instance with the wrapped type"

	^ super nonNullType
		performs: [ :tokens | 
			| node |
			node := GQLSNonNullTypeNode new.
			node wrappedType: (tokens at: 1).
			node position: (tokens at: 1) position.
			node ]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> objectType [
	"Return a GQLSObjectTypeNode instance with the objectTypeName, the fields and the position on the text schema"

	^ super objectType
		performs: [ :tokens | 
			| node |
			node := GQLSObjectTypeNode new.
			node description: (tokens at: 2).
			node name: (tokens at: 5) inputValue.
			node addFields: (tokens at: 7).
			node implements: (tokens at: 6).
			node position: (tokens at: 5) start.
			node addComments: (tokens atAll: #( 1 3 8 )).
			]
]

{ #category : #accessing }
GQLSchemaGrammarEvaluator >> objectTypeExtWithInterface [
	^ super objectTypeExtWithInterface
		performs: [ :tokens | 
			| node |
			node := GQLSObjectTypeNode new.
			node name: (tokens at: 2) inputValue.
			node implements: (tokens at: 3).
			node position: (tokens at: 2) start.
			node addComments: (tokens atAll: #( 4 )).
			]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> objectTypeExtension [
	"Return a GQLSObjectTypeNode instance with the objectTypeName, the fields and the position on the text schema"

	^ super objectTypeExtension
		performs: [ :tokens | 
			| node |
			node := GQLSObjectTypeNode new.
			node name: (tokens at: 2) inputValue.
			node addFields: (tokens at: 4).
			node implements: (tokens at: 3).
			node position: (tokens at: 2) start.
			node addComments: (tokens atAll: #( 5 )).
			]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> parameter [
	"Return a GQLSParameterNode instance with the parameterName, inputType and the position on the text schema"

	^ super parameter
		performs: [ :tokens | 
			| node |
			node := GQLSInputObjectFieldNode new.
			node description: (tokens at: 1).
			node name: (tokens at: 2) inputValue.
			node type: (tokens at: 4).
			node position: (tokens at: 2) start.
			node ]
]

{ #category : #accessing }
GQLSchemaGrammarEvaluator >> parameters [
"Return the list of parameter"
	^ super parameters
		performs: [ :tokens | tokens at: 2 ]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> rootOperationType [
	"Return a GQLSRootOperationType instance with the name and position on the text schema"

	^ super rootOperationType
		performs: [ :tokens | 
			| node |
			node := GQLSRootOperationTypeNode new.
			node key: (tokens at: 2) inputValue.
			node name: (tokens at: 4) inputValue.
			node position: (tokens at: 2) start.
			node addComments: (tokens atAll: #(1 5)).
			node ]
]

{ #category : #accessing }
GQLSchemaGrammarEvaluator >> rootOperationTypes [
"Return the [rootOperationType]"
	^ super rootOperationTypes 
		performs: [ :tokens | tokens at: 2 ]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> schema [
	"Return a GQLSchemaNode instance with the types defined on the text schema"

	^ super schema
		performs: [ :tokens | 
			| node |
			node := GQLSSchemaNode new.
			node addTypes: (tokens reject: [:item | item isTypeExtensionNode ]).
			node addTypeExtensions: (tokens select: [:item | item isTypeExtensionNode ])
			]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> schemaDefinition [
	"Return a GQLSSchemaDefinition instance with the rootOperationTypes, position and comments"

	^ super schemaDefinition 
		performs: [ :tokens | 
			| node |
			node := GQLSSchemaDefinitionNode new.
			node rootOperationTypes: (tokens at: 3).
			node position: (tokens at: 2) start.
			node addComments: (tokens atAll: #(1 4) ).
			]
]

{ #category : #accessing }
GQLSchemaGrammarEvaluator >> start [
	"Return a parser accepting schema and then the input ends"

	^ schema end
]

{ #category : #accessing }
GQLSchemaGrammarEvaluator >> stringType [
	"Return a GQLSStringType instance"

	^ super stringType
		performs: [ :tokens | 
			| node |
			node := GQLSStringTypeNode new.
			node ]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> typeSystemExtension [
	^ super typeSystemExtension
		performs: [ :tokens | 
			| node value |
			node := GQLSTypeSystemExtension new.
			value := (tokens at: 3).
			node value: value.
			node name: value name.
			node position: value position.
			node addComments: (tokens atAll: #(1) ).
			node ]
]

{ #category : #accessing }
GQLSchemaGrammarEvaluator >> typeSystemToExtend [
	^ super typeSystemToExtend 
		performs: [ :tokens | tokens ]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> unionType [
	"Return a GQLSUnionTypeNode instance with the union name, the values and the position on the text schema"

	^ super unionType
		performs: [ :tokens | 
			| node |
			node := GQLSUnionTypeNode new.
			node description: (tokens at: 2).
			node name: (tokens at: 5) inputValue.
			node addTypes: (tokens at: 7).
			node position: (tokens at: 5) start.
			node addComments: (tokens atAll: #(1 3 8)) 
		]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> unionTypeExtension [
	"Return a GQLSUnionTypeNode instance with the union name, the values and the position on the text schema"

	^ super unionTypeExtension
		performs: [ :tokens | 
			| node |
			node := GQLSUnionTypeNode new.
			node name: (tokens at: 2) inputValue.
			node addTypes: (tokens at: 4).
			node position: (tokens at: 2) start.
			node addComments: (tokens atAll: #(5)) 
		]
]

{ #category : #grammar }
GQLSchemaGrammarEvaluator >> unionValuesList [
	"Return an array"

	^ super unionValuesList
		performs: [ :tokens |
			tokens reject: #isCharacter thenCollect: #inputValue. ]
]
