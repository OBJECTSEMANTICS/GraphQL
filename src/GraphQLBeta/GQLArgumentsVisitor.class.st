"
I follow the specification
https://facebook.github.io/graphql/draft/#sec-Validation.Arguments
"
Class {
	#name : #GQLArgumentsVisitor,
	#superclass : #GQLNodeVisitor,
	#instVars : [
		'currentField'
	],
	#category : #'GraphQLBeta-Visitors'
}

{ #category : #errors }
GQLArgumentsVisitor >> addErrorUnknownArgFor: arg [
	| s current field |
	current := current := schemaContextStack top.
	field := currentField.
	s := String new writeStream.
	s 
		nextPutAll: 'Unknown argument "';
		nextPutAll: arg name.
	field class = GQLSFieldNode ifTrue: [ 
		s
			nextPutAll: '" on field "';
			nextPutAll: field name;
			nextPutAll: '" on type "';
			nextPutAll: current name ]
	ifFalse: [ 
		s 
			nextPutAll: '" on directive "@';
			nextPutAll: field name ]. 
	s nextPutAll: '".'.
	self
		addErrorMessage: s contents
		node: arg
]

{ #category : #accesing }
GQLArgumentsVisitor >> realValueFor: value [
	value isVariableNode ifFalse: [ ^ value ].
	^ context variables 
		at: value value
		ifPresent:[:var | var value]
		ifAbsent:[ value ]
]

{ #category : #validation }
GQLArgumentsVisitor >> validateArguments: node [
	self validateOcurrences: node.
	self validateNotNullFor: node.
]

{ #category : #visiting }
GQLArgumentsVisitor >> validateCoerceArgument: argument in: argSchema [
	| type s realValue |
	argument value isVariableNode ifTrue: [ ^ self ].
	type := argSchema type.
	realValue := self realValueFor: argument value.
	(type canCoerce: realValue on: schema) ifTrue: [ ^ self ].
	s := String new writeStream.
	s
		nextPutAll: 'Argument "';
		nextPutAll: argument name;
		nextPutAll: '" has invalid value '.
	argument printValueOn: s.
	s nextPutAll: '. Expected type "'.
	type printOn: s.
	s nextPutAll: '".'.
	self addErrorMessage: s contents node: realValue
]

{ #category : #validation }
GQLArgumentsVisitor >> validateNotNullFor: node [
	| field |
	currentField ifNil: [ ^ self ].
	currentField isNullType ifTrue: [ ^ self ].
	field := currentField.
	field arguments do: [ :argS | 
		node arguments 
			detect: [ :arg | argS name = arg name ] 
			ifFound: [ :arg | "is ok"] 
			ifNone: [ | type | 
				type := argS type.
				type class = GQLSNonNullTypeNode ifTrue: [ 
					| s |
					s := String new writeStream.
					field class = GQLSFieldNode 
						ifTrue: [ s nextPutAll: 'Field "' ] 
						ifFalse: [ s nextPutAll: 'Directive "@'].
					s
						nextPutAll: field name;
						nextPutAll: '" argument "';
						nextPutAll: argS name;
						nextPutAll: '" of type "'.
					argS type printOn: s.
					s nextPutAll: '" is required but not provided.'.
					self 
						addErrorMessage: s contents
						node: node
					 ] ] ].
]

{ #category : #validation }
GQLArgumentsVisitor >> validateOcurrences: node [
	| ocurrences |
	ocurrences := node arguments groupedBy: [ :arg | arg name ].
	ocurrences keysAndValuesDo: [ :k :nodes |
		nodes size > 1 ifTrue: [ | s |
			s := String new writeStream.
			s nextPutAll: 'There can be only one argument named "';
				nextPutAll: k;
				nextPutAll: '".'.
			self
				addErrorMessage:  s contents
				nodes: nodes ].
		 ].
	
]

{ #category : #visiting }
GQLArgumentsVisitor >> visitArgumentNode: node [
	currentField ifNil: [ ^ self ].
	currentField isNullType ifTrue: [ ^ self ].
	currentField arguments 
		detect: [ :argS | argS name = node name ]
		ifFound: [ :argS | self validateCoerceArgument: node in: argS ]
		ifNone: [self addErrorUnknownArgFor: node ]
]

{ #category : #visiting }
GQLArgumentsVisitor >> visitDirectiveNode: node [
	currentField := schema getDirective: node name.
	self validateArguments: node.
	node arguments do: [ : arg | arg accept: self ].
]

{ #category : #visiting }
GQLArgumentsVisitor >> visitDocumentNode: node [
	self stackedOn: node do: [
		node operations do: [ :op | op accept: self ].
		node fragments do: [ :f | f accept: self ].
	 ].
	
]

{ #category : #visiting }
GQLArgumentsVisitor >> visitFragmentNode: node [
	| type |
	type := self getFragmentTypeOf: node typeCondition.
	schemaContextStack push: type.
	node selectionSet accept: self.
	schemaContextStack pop.
]

{ #category : #visiting }
GQLArgumentsVisitor >> visitInlineFragmentNode: node [
	node directives do: [ :d | d accept: self ].
	
]

{ #category : #visiting }
GQLArgumentsVisitor >> visitNonScalarFieldNode: node [
	| current field type |
	current := schemaContextStack top.
	field := current getField: node name.
	type := field isNil 
		ifTrue: [ GQLSNullTypeNode instance ]
		ifFalse: [ field type rawType: schema ].
	schemaContextStack push: type.
	currentField := field.
	self validateArguments: node.
	node arguments do: [ :arg | arg accept: self ].
	node directives do: [ :d | d accept: self ].
	node selectionSet accept: self.
	schemaContextStack pop.
]

{ #category : #visiting }
GQLArgumentsVisitor >> visitOperationNode: node [
	self stackedType: node do: [  
		node selectionSet accept: self.
		node directives do: [ :d | d accept: self ] ].
	
]

{ #category : #visiting }
GQLArgumentsVisitor >> visitScalarFieldNode: node [
	| current |
	current := schemaContextStack top.
	currentField :=current getField: node name.
	self validateArguments: node.
	node arguments do: [ :arg | arg accept: self ].
	node directives do: [ :d | d accept: self ].
	
]

{ #category : #visiting }
GQLArgumentsVisitor >> visitSelectionSetNode: node [
	node selections do: [ :f | f accept: self ].
]
