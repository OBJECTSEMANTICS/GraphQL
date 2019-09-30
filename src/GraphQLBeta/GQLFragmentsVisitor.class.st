"
I follow the specification
https://facebook.github.io/graphql/draft/#sec-Validation.Fragments
"
Class {
	#name : #GQLFragmentsVisitor,
	#superclass : #GQLNodeVisitor,
	#instVars : [
		'usedFragments',
		'currentFragment'
	],
	#category : #'GraphQLBeta-Visitors'
}

{ #category : #validation }
GQLFragmentsVisitor >> getPossibleTypes: ref [
	| result type |
	type := self getFragmentTypeOf: ref.
	result := Set new.
	type isObjectType ifTrue: [ 
		result add: type ].
	type isInterfaceType ifTrue: [ 
		type implementors do: [ :i | result add: i ].
	 ].
	type isUnionType ifTrue: [
		type namedTypes do: [ :s | 
			result add: (schema getType: s)].
		].
	^ result 
]

{ #category : #validation }
GQLFragmentsVisitor >> validateFragmentSpreadPossibility: node fragmentType: fragmentType parentType: parentType [
	| applicableTypes s types1 types2 |
	types1 := self getPossibleTypes: fragmentType.
	types1 ifEmpty: [ ^ self ].
	types2 := self getPossibleTypes: parentType.
	types2 ifEmpty: [ ^ self ].
	applicableTypes := types1 intersection: types2.
	applicableTypes
		ifEmpty: [ s := String new writeStream.
			s nextPutAll: 'Fragment '.
			node class = GQLInlineFragmentNode
				ifFalse: [ s
						nextPutAll: '"';
						nextPutAll: node name;
						nextPutAll: '" ' ].
			s nextPutAll: 'cannot be spread here as objects of type "'.
			fragmentType printOn: s.
			s nextPutAll: '" can never be of type "'.
			parentType printOn: s.
			s nextPutAll: '".'.
			self addErrorMessage: s contents node: node ]
]

{ #category : #validation }
GQLFragmentsVisitor >> validateFragmentType: f [
	| stype type |
	type := f typeCondition.
	type ifNil: [ ^ self ].
	stype := schema getType: type name.
	stype 
		ifNil: [ self addErrorMessage: 'Unkwown type "', type name, '".' node: type ]
		ifNotNil: [ 
			(stype isObjectType | stype isInterfaceType | stype isUnionType) ifFalse: [ 
				| s |
				s := String new writeStream.
				s nextPutAll: 'Fragment '.
				f class = GQLFragmentNode ifTrue: [ 
					s nextPutAll: '"';
						nextPutAll: f name;
						nextPutAll: '" '].
				s nextPutAll: 'cannot condition on non composite type "'.
				type printOn: s.
				s nextPutAll: '"'.
				self addErrorMessage: s contents node: type ]
			 ]
	
]

{ #category : #validation }
GQLFragmentsVisitor >> validateFragments: fragments [
	| ocurrences  |
	ocurrences := fragments groupedBy: [ :f | f name  ].
	ocurrences keysAndValuesDo: [ :k : list |
		list size > 1 ifTrue: [ 
			self
				addErrorMessage: 'There can be only one fragment named "', k, '".'
				nodes: list. ]
		 ].
	
	fragments do: [ :f | | visited s |
		self validateFragmentType: f.
		(usedFragments includes: f name) ifFalse: [ 
			s := String new writeStream.
			s 
				nextPutAll: 'Fragment "'; 
				nextPutAll: f name; 
				nextPutAll: '" is never used.'.
			self 
				addErrorMessage: s contents
				node: f ].
		visited := Set new.
		(document hasCycle: f with: visited) ifTrue: [ 
			| node |
			f setHasCycle: true.
			node := (visited intersection: f targetSpreads) asArray at: visited size.
			s := String new writeStream.
			s 
				nextPutAll: 'Cannot spread fragment "';
				nextPutAll: f name;
				nextPutAll: '" with itself via ';
				nextPutAll: node name.
			self
				addErrorMessage: s contents
				node: node ]	
		 ].
]

{ #category : #visiting }
GQLFragmentsVisitor >> visitDocumentNode: node [
	self stackedOn: node do: [ 
		usedFragments := Set new.
		node operations do: [ :op | op accept: self ].
		node fragments do: [ :f | f accept: self ].
		self validateFragments: node fragments ].
]

{ #category : #visiting }
GQLFragmentsVisitor >> visitFragmentNode: node [
	| type |
	type := self getFragmentTypeOf: node typeCondition.
	schemaContextStack push: type.
	currentFragment := node.
	node selectionSet accept: self.
	schemaContextStack pop.
]

{ #category : #visiting }
GQLFragmentsVisitor >> visitFragmentSpreadNode: node [
	usedFragments add: node name.
	
	document fragments 
		detect: [ :f | f name = node name ]
		ifFound: [ :f | 
			| current |
			current := schemaContextStack top.
			self 
				validateFragmentSpreadPossibility: node  
				fragmentType: f typeCondition 
				parentType: current ]
		ifNone: [ self 
			addErrorMessage: 'Unknown fragment "', node name, '".' 
			node: node]. 
]

{ #category : #visiting }
GQLFragmentsVisitor >> visitInlineFragmentNode: node [
	| current type ftype |
	current := schemaContextStack top.
	type := node typeCondition.
	type ifNil: [ type := current ].
	ftype := currentFragment 
		ifNil: [ current ] 
		ifNotNil: [ currentFragment typeCondition ].
	self 
		validateFragmentSpreadPossibility: node 
		fragmentType: ftype 
		parentType: type.
	self validateFragmentType: node.
	type := type rawType: schema.
	schemaContextStack push: type.
	node selectionSet accept: self.
	schemaContextStack pop.
]

{ #category : #visiting }
GQLFragmentsVisitor >> visitNonScalarFieldNode: node [
	| current type field|
	current := schemaContextStack top.
	field := current getField: node name.
	type := field isNil 
		ifTrue: [ GQLSNullTypeNode instance ]
		ifFalse: [ field type rawType: schema ].
	schemaContextStack push: type.
	node selectionSet accept: self.
	schemaContextStack pop.
]

{ #category : #visiting }
GQLFragmentsVisitor >> visitOperationNode: node [
	self stackedType: node do: [  
		node selectionSet accept: self ]
	
]

{ #category : #visiting }
GQLFragmentsVisitor >> visitSchemaFieldNode: node [
	schemaContextStack push: (GQLSSchemaNode metaSchema getType: 'GQLSSchemaNode').
	node selectionSet accept: self.
	schemaContextStack pop.
]

{ #category : #visiting }
GQLFragmentsVisitor >> visitSelectionSetNode: node [
	node selections do: [ :f | f accept: self ].
	
]
