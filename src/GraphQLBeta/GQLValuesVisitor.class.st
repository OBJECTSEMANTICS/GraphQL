"
My instances validate all the ObjectInputs in the document
https://facebook.github.io/graphql/draft/#sec-Values
"
Class {
	#name : #GQLValuesVisitor,
	#superclass : #GQLNodeVisitor,
	#instVars : [
		'currentField'
	],
	#category : #'GraphQLBeta-Visitors'
}

{ #category : #validation }
GQLValuesVisitor >> getType: arg [
	currentField ifNil: [ ^ nil ].
	currentField isNullType ifTrue: [ ^ nil ].
	^ currentField arguments 
		detect: [ :sarg | sarg name = arg name]
		ifFound: [ :sarg| sarg ]
		ifNone: [ nil ]
]

{ #category : #'as yet unclassified' }
GQLValuesVisitor >> getTypeNameOf: aType [
	^ [ aType type isWrappedType ifTrue: [ 
		self getTypeNameOf: aType type wrappedType
	] ifFalse: [ 
		aType type name
	]] on: MessageNotUnderstood do: [ :ex | aType name ]
]

{ #category : #validation }
GQLValuesVisitor >> validateArgument: arg [ 
	| type value |
	value := arg value.
	type := self getType: arg.
	type ifNil: [ ^ self ].
	type := schema getType: (self getTypeNameOf: type).
	self validateValue: value type: type.
]

{ #category : #validation }
GQLValuesVisitor >> validateFieldNode: node [
	node arguments do: [ :arg | 
		self validateArgument: arg ].
]

{ #category : #validation }
GQLValuesVisitor >> validateObjectInputField: field on: sfield type: type [
	| s |
	sfield ifNil: [ 
		s := String new writeStream.
		s
			nextPutAll: 'Field "';
			nextPutAll: field name;
			nextPutAll: '" is not defined by type ';
			nextPutAll: type name.
		self addErrorMessage: s contents node: field.
		^ self ].
	(sfield type canCoerce: field value on: schema) ifTrue: [ ^ self ].
	s := String new writeStream.
	s nextPutAll: 'Expected type '.
	sfield type printOn: s.
	s nextPutAll: ', found '.
	field value printOn: s.
	s nextPutAll: '.'.
	self addErrorMessage: s contents node: field
]

{ #category : #validation }
GQLValuesVisitor >> validateValue: value type: type [
	| ocurrences |
	value class = GQLObjectNode ifFalse: [ ^ self ].
	ocurrences := OrderedDictionary new.
	value objectFields do: [ :field|
		| sfield |
		(ocurrences 
			at: field name 
			ifAbsentPut: [ OrderedCollection new ]) add: field.
		sfield := type getField: field name.
		self validateObjectInputField: field on: sfield type: type ].
	ocurrences keysAndValuesDo: [ :k :nodes | 
		nodes size > 1 ifTrue: [
			self addErrorMessage: 'There can be only one input field named "', k, '".' nodes: nodes 
			]].
]

{ #category : #validation }
GQLValuesVisitor >> validateVariableDefaultValue: var [
	| type |
	var defaultValue ifNil: [ ^ self ].
	type := schema getType: var type name.
	self validateValue: var defaultValue type: type.
]

{ #category : #visiting }
GQLValuesVisitor >> visitDocumentNode: node [
	self stackedOn: node do: [ 
		node operations do: [ :op | op accept: self ].
		node fragments do: [ :frag | frag accept: self ].
	].
]

{ #category : #visiting }
GQLValuesVisitor >> visitFragmentNode: node [
	| type |
	type := self getFragmentTypeOf: node typeCondition.
	schemaContextStack push: type.
	node selectionSet accept: self.
	schemaContextStack pop.
]

{ #category : #visiting }
GQLValuesVisitor >> visitInlineFragmentNode: node [
	
	node directives do: [ :dir | dir accept: self ].

]

{ #category : #visiting }
GQLValuesVisitor >> visitNonScalarFieldNode: node [
	| current type field|
	current := schemaContextStack top.
	field := current getField: node name.
	type := field isNil 
		ifTrue: [ GQLSNullTypeNode instance ]
		ifFalse: [ field type rawType: schema ].
	schemaContextStack push: type.
	node selectionSet accept: self.
	schemaContextStack pop.
	node directives do: [ :dir | dir accept: self ].
	currentField := field.
	self validateFieldNode: node.
]

{ #category : #visiting }
GQLValuesVisitor >> visitOperationNode: node [
	self stackedType: node do: [  
		node selectionSet accept: self.
		node variableDefinitions do: [ :var | self validateVariableDefaultValue: var ].
	]
]

{ #category : #visiting }
GQLValuesVisitor >> visitScalarFieldNode: node [
	| current |
	current := schemaContextStack top.
	node directives do: [ :dir | dir accept: self ].
	currentField := (current isUnionType or: [ current isScalarType ])
		ifTrue: [ nil ]
		ifFalse: [  current getField: node name   ].
	self validateFieldNode: node.
	
]

{ #category : #visiting }
GQLValuesVisitor >> visitSelectionSetNode: node [
	node selections do: [ :fieldNode | fieldNode accept: self ].
]
