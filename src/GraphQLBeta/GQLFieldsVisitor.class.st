"
I use this specification
https://facebook.github.io/graphql/draft/#sec-Validation.Fields
"
Class {
	#name : #GQLFieldsVisitor,
	#superclass : #GQLNodeVisitor,
	#instVars : [
		'visitedFields'
	],
	#category : #'GraphQLBeta-Visitors'
}

{ #category : #accessing }
GQLFieldsVisitor >> getFieldsForNameFrom: node [
	| fieldsForName fill |
	fieldsForName := OrderedCollection new.
	
	fill := nil.
	fill := [ :n :p |
		n selections do: [ :selection |
			selection
				ifField: [ fieldsForName add: p -> selection ]
				ifFragment: [ | fragment  |
					fragment := document getFragment: selection name.
					(fragment isNil or: [ fragment hasCycle: document ]) 
						ifFalse: [ fill value: fragment selectionSet value: (self getTypeParent: fragment) ]
					 ]
				ifInline: [ fill value: selection selectionSet value: (self getTypeParent: selection)].
		].
	].
	fill value: node value: (self getTypeParent: node).
	"avoid repeating fields"
	fieldsForName copy do: [ :assoc |
		visitedFields at: assoc value 
			ifPresent: [ :v | fieldsForName remove: assoc ] 
			ifAbsent: [ visitedFields at: assoc value put: assoc ] ].
	^ fieldsForName
]

{ #category : #accessing }
GQLFieldsVisitor >> getTypeParent: node [
	^ node class = GQLSelectionSetNode 
		ifTrue: [ schemaContextStack top ]
		ifFalse: [
			node typeCondition 
				ifNil: [ schemaContextStack top ]
				ifNotNil: [ schema getType: node typeCondition name  ] ]
]

{ #category : #validation }
GQLFieldsVisitor >> validateField: assoc1 onField: assoc2 [
	| nodes f1 f2 parentType1 parentType2 type1 type2 |
	
	f1 := assoc1 value.
	f2 := assoc2 value.
	f1 == f2 ifTrue: [ ^ self ].
	parentType1 := assoc1 key.
	parentType2 := assoc2 key.
	parentType1 ifNil: [ ^ self ].
	parentType2 ifNil: [ ^ self ].
	parentType1 isObjectType ifFalse: [ ^ self ].
	parentType2 isObjectType ifFalse: [ ^ self ].
	type1 := parentType1 getFieldType: f1 name.
	type2 := parentType2 getFieldType: f2 name.
	
	f1 key = f2 key ifFalse: [ ^ self ].
	
	nodes := Array with: f1 with: f2.
	f1 name = f2 name ifTrue: [ 
		parentType1 = parentType2 ifTrue: [ 
			(f1 hasSameArguments: f2 arguments) ifFalse: [
				self 
					addErrorMessage: 'Fields "', f1 key,'" conflict because they have differing arguments. Use different aliases on the fields to fetch both if this was intentional.'
				nodes: nodes ]
			] ifFalse: [ "self halt." ]
	 ] ifFalse: [ 
		type1 class = type2 class ifTrue: [ ^ self ].
		
		self 
			addErrorMessage: 'Fields "', f1 key, 
		'" conflict because "', f1 name, '" and "', f2 name,'" are different fields. Use different aliases on the fields to fetch both if this was intentional.'
			nodes: nodes ].
]

{ #category : #validation }
GQLFieldsVisitor >> validateFieldsMerging: node [
	| fieldsForName |
	fieldsForName := self getFieldsForNameFrom: node.
	1 to: fieldsForName size -1 do: [ :i |
		i +1 to: fieldsForName size do: [ :k | | assoc1 assoc2 |
			assoc1 := fieldsForName at: i.
			assoc2 := fieldsForName at: k.
			self validateField: assoc1 onField: assoc2 ] ].
]

{ #category : #validation }
GQLFieldsVisitor >> validateScalarFieldNode: node on: field [
	| type s |
	type := field type rawType: schema.
	type isNullType ifTrue: [ ^ self ].
	type isScalarType ifTrue: [ ^ self ].
	s := String new writeStream.
	s
		nextPutAll: 'Field "';
		nextPutAll: node name;
		nextPutAll: '" on type "'.
	field type printOn: s.
	s
		nextPutAll: '" must have selection of subfields. Did you mean "';
		nextPutAll: node name;
		nextPutAll: ' { ... }"?'.
	self addErrorMessage: s contents node: node
]

{ #category : #visiting }
GQLFieldsVisitor >> visitDocumentNode: node [
	self stackedOn: node do: [ 
		visitedFields := Dictionary new.
		node operations do: [ :op | op accept: self ].
		node fragments do: [ :f |  f accept: self ].
	]
]

{ #category : #visiting }
GQLFieldsVisitor >> visitFragmentNode: node [
	| type |
	type := self getFragmentTypeOf: node typeCondition.
	schemaContextStack push: type.
	node selectionSet accept: self.
	schemaContextStack pop.
]

{ #category : #visiting }
GQLFieldsVisitor >> visitInlineFragmentNode: node [
	| current type |
	current := schemaContextStack top.
	type := node typeCondition.
	type ifNil: [ type := current].
	type := type rawType: schema.
	(type isNil or: [type isScalarType]) 
		ifTrue: [ type := GQLSNullTypeNode instance ].
	schemaContextStack push: type.
	node selectionSet accept: self.
	schemaContextStack pop.
]

{ #category : #visiting }
GQLFieldsVisitor >> visitNonScalarFieldNode: node [
	| current field type |
	current := schemaContextStack top.
	field := current getField: node name.
	field ifNil: [ 
		self 
			addErrorMessage: 'Cannot query field "', node name, '" on type "', current name, '"'
		 	node: node.
		^ self ].
	type := field type rawType: schema.
	type isScalarType ifTrue: [ 
		self addErrorMessage: 'Field "', node name, '" must not have selection since type "', type name, '" has no subfields.'
		 node: node selectionSet
	] ifFalse: [ 
		schemaContextStack push: type.
		node selectionSet accept: self.
		schemaContextStack pop.
	].
	
]

{ #category : #visiting }
GQLFieldsVisitor >> visitOperationNode: node [
	| isNil |
	isNil := self 
		stackedType: node 
		do: [ node selectionSet accept: self ].
		
	isNil ifTrue: [ 
		self 
			addErrorMessage: node type, ' not supported, review schema definition.' 
			node: node ]
	
]

{ #category : #visiting }
GQLFieldsVisitor >> visitScalarFieldNode: node [
	| current hasField field |
	current := schemaContextStack top.
	field := nil.
	hasField := (field := current getField: node name) isNotNil.
	hasField ifTrue: [ 
		field 
			ifNotNil: [ self validateScalarFieldNode: node on: field ]
	] ifFalse: [ 
		self 
			addErrorMessage: 'Cannot query field "', node name, '" on type "', current name, '"'
			node: node ].
]

{ #category : #visiting }
GQLFieldsVisitor >> visitSelectionSetNode: node [
	self validateFieldsMerging: node.
	node selections do: [ :f | f accept: self ].
]
