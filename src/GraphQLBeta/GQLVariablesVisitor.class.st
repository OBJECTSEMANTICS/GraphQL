"
My instances can evaluate all variables in the document request and send errors when something is wrong
https://facebook.github.io/graphql/draft/#sec-Validation.Variables
"
Class {
	#name : #GQLVariablesVisitor,
	#superclass : #GQLNodeVisitor,
	#instVars : [
		'currentOperation',
		'usedVariables',
		'currentField'
	],
	#category : #'GraphQLBeta-Visitors'
}

{ #category : #validation }
GQLVariablesVisitor >> currentOperationVariable: arg [
	currentOperation class = GQLOperationNode ifFalse: [ ^ nil ].
	currentOperation variableDefinitions ifNil: [ ^ nil ].
	^ currentOperation variableDefinitions
		detect: [ :var | var name = arg value value ]
		ifFound: [ :var | var ]
		ifNone: [ nil ]
]

{ #category : #validation }
GQLVariablesVisitor >> validateFieldNode: node [
	| var |
	node arguments do: [ :arg | 
		arg value isVariableNode ifTrue: [ 
			usedVariables add: arg value value.
			var := self currentOperationVariable: arg.
			var isNil ifTrue: [ 
				| s |
				s := String new writeStream.
				s 
					nextPutAll: 'Variable "';
					nextPutAll: arg name.
				currentOperation class = GQLOperationNode ifTrue: [
					s 
						nextPutAll: '" is not defined by operation "';
						nextPutAll: currentOperation name;
						nextPutAll: '".'.
					] ifFalse: [ 
					s nextPutAll: '" is not defined.' ].
					
				self 
					addErrorMessage: s contents
				 	nodes: (Array with: arg value with: currentOperation) 
			] ifFalse: [ 
				currentField ifNil: [ ^ self ].
				currentField arguments 
					detect: [ :sarg | sarg name = arg name ]
					ifFound: [:sarg | sarg type printString = var type printString ifFalse: [ 
						| s |
						s := String new writeStream.
						s 
							nextPutAll: 'Variable "';
							nextPutAll: var name;
							nextPutAll: '" of type "'.
						var type printOn: s.
						s nextPutAll: '" used in position expecting type "'.
						sarg type printOn: s.
						s nextPutAll: '".'.
						self addErrorMessage: s contents node: (Array with: var with: arg value)
						 ] ].
			 ]
		] ].
	
]

{ #category : #visiting }
GQLVariablesVisitor >> validateVariableContextValue: var [
	context variables 
		detect: [ :variable | variable name = var name ]
		ifFound: [ :variable |
			| s |
			(var type canCoerce: variable value on: schema) 
				ifTrue: [ ^ self ].
			s := String new writeStream.
			s 
				nextPutAll: 'Variable "$';
				nextPutAll: var name;
				nextPutAll: '" got invalid value '.
			variable value printOn: s.
			s nextPutAll: '. Expected type "'.
			var type printOn: s.
			s nextPutAll: '".'.
			self addErrorMessage: s contents node: var.
			]
		ifNone: [ var type class = GQLSNonNullTypeNode ifTrue: [ 
			| s |
			s := String new writeStream.
			s 
				nextPutAll: 'Variable "$';
				nextPutAll: var name;
				nextPutAll: '" of required type "'.
			var type printOn: s.
			s nextPutAll: '" was not provided.'.
			self addErrorMessage: s contents node: var. ] ]
]

{ #category : #validation }
GQLVariablesVisitor >> validateVariableDefaultValue: var [
	| s |
	var defaultValue ifNil: [ ^ self ].
	(var type canCoerce: var defaultValue on: schema) ifTrue: [ ^ self ].
	(var type isObjectInputType: schema) ifTrue: [ ^ self ].
	s := String new writeStream.
	s nextPutAll: 'Expected type '.
	var type printOn: s.
	s nextPutAll: ', found '.
	var defaultValue printOn: s.
	s nextPutAll: '.'.
	self addErrorMessage: s contents node: var defaultValue
]

{ #category : #validation }
GQLVariablesVisitor >> validateVariableType: var [
	| type s |
	
	type := var type rawType: schema.
	type ifNil: [ 
		^ self 
			addErrorMessage:  'Unknown type "', var type name, '".'
			node: var
		 ].
	type isInputType ifTrue: [ ^ self ].
	s := String new writeStream.
	s 
		nextPutAll: 'Variable "$';
		nextPutAll: var name;
		nextPutAll: '" cannot be non-input type "'.
	var type printOn: s.
	s nextPutAll: '".'.
	self addErrorMessage: s contents node: var.
	

]

{ #category : #visiting }
GQLVariablesVisitor >> visitDirectiveNode: node [
	self validateFieldNode: node.
]

{ #category : #visiting }
GQLVariablesVisitor >> visitDocumentNode: node [
	self stackedOn: node do: [  
	node operations do: [ :op | 
		currentOperation := op.
		usedVariables := OrderedCollection new.
		op accept: self ]
	].
]

{ #category : #visiting }
GQLVariablesVisitor >> visitFragmentSpreadNode: node [
	| fragment |
	node directives do: [ :dir | dir accept: self ].
	fragment := document getFragment: node name.
	fragment ifNil: [ ^ self ].
	(fragment hasCycle: document) ifTrue: [ ^ self ].
	fragment selectionSet accept: self.
]

{ #category : #visiting }
GQLVariablesVisitor >> visitInlineFragmentNode: node [
	
	node directives do: [ :dir | dir accept: self ].

]

{ #category : #visiting }
GQLVariablesVisitor >> visitNonScalarFieldNode: node [
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
GQLVariablesVisitor >> visitOperationNode: node [
	| ocurrences |
	self stackedType: node do: [  
		node selectionSet accept: self.
		ocurrences := node variableDefinitions groupedBy: #name.
		ocurrences keysAndValuesDo: [ :k :list |
			list size > 1 ifTrue: [ 
				self 
					addErrorMessage: 'There can be only one variable named "', k,'".'
					nodes: list ] ].
	
		node variableDefinitions do: [ :var | 
			self validateVariableType: var.
			self validateVariableDefaultValue: var.
			self validateVariableContextValue: var.
			(usedVariables anySatisfy: [ :usedVar | usedVar = var name ]) ifFalse: [ 
				self 
					addErrorMessage: 'Variable "$', var name, '" is never used in operation "', node name, 	'".'
					node: var.].
		].

	]
]

{ #category : #visiting }
GQLVariablesVisitor >> visitScalarFieldNode: node [
	| current |
	current := schemaContextStack top.
	node directives do: [ :dir | dir accept: self ].
	currentField := current getField: node name.
	self validateFieldNode: node.
	
]

{ #category : #visiting }
GQLVariablesVisitor >> visitSelectionSetNode: node [
	node selections do: [ :fieldNode | fieldNode accept: self ].
	
]
