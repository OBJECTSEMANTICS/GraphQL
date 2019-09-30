"
I can visit all the directives in the document and validate if they apply in that section
https://facebook.github.io/graphql/draft/#sec-Validation.Directives
"
Class {
	#name : #GQLDirectivesVisitor,
	#superclass : #GQLNodeVisitor,
	#instVars : [
		'currentLocation'
	],
	#category : #'GraphQLBeta-Visitors'
}

{ #category : #visiting }
GQLDirectivesVisitor >> validateDirectiveLocation: node [
	| ocurrences |
	currentLocation := node.
	ocurrences := OrderedDictionary new.
	
	node directives do: [ :d | 
		(ocurrences
			at: d name 
			ifAbsentPut: [ OrderedCollection new ]) add: d.
		d accept: self ].
	ocurrences keysAndValuesDo: [ :k :nodes |
		nodes size > 1 ifTrue: [ 
			self 
				addErrorMessage: 'The directive "',k,'" can only be used once at this location.' 
				nodes: nodes
			 ] ]
]

{ #category : #visiting }
GQLDirectivesVisitor >> visitDirectiveNode: node [
	| directive |
	directive := schema getDirective: node name.
	directive ifNil: [ 
		^ self 
			addErrorMessage: 'Unknown directive "', node name, '".'
			node: node ].
	(directive directiveLocations includes: currentLocation class) ifFalse: [ 
		self 
			addErrorMessage: 'Directive "', node name, '" may not be used on ', currentLocation class nodeName, '.'
			node: node
		 ].
]

{ #category : #visiting }
GQLDirectivesVisitor >> visitDocumentNode: node [
	node operations do: [ :op | op accept: self ].
	node fragments do: [ :f | f accept: self  ]
]

{ #category : #visiting }
GQLDirectivesVisitor >> visitFragmentNode: node [
	currentLocation := node.
	node directives do: [ :d | d accept: self ].
	node selectionSet accept: self.
]

{ #category : #visiting }
GQLDirectivesVisitor >> visitInlineFragmentNode: node [
	self validateDirectiveLocation: node
]

{ #category : #visiting }
GQLDirectivesVisitor >> visitIntrospectionFieldNode: node [
	self validateDirectiveLocation: node.
]

{ #category : #visiting }
GQLDirectivesVisitor >> visitNonScalarFieldNode: node [
	self validateDirectiveLocation: node
]

{ #category : #visiting }
GQLDirectivesVisitor >> visitOperationNode: node [ 
	self validateDirectiveLocation: node.
	node selectionSet accept: self
	
]

{ #category : #visiting }
GQLDirectivesVisitor >> visitScalarFieldNode: node [
	self validateDirectiveLocation: node.
]

{ #category : #visiting }
GQLDirectivesVisitor >> visitSchemaFieldNode: node [
	self validateDirectiveLocation: node.
]

{ #category : #visiting }
GQLDirectivesVisitor >> visitSelectionSetNode: node [ 
	node selections do: [ :s | s accept: self ]
]

{ #category : #visiting }
GQLDirectivesVisitor >> visitTypeFieldNode: node [
	self validateDirectiveLocation: node.
]

{ #category : #visiting }
GQLDirectivesVisitor >> visitTypenameFieldNode: node [
	self validateDirectiveLocation: node.
]
