"
I validate the operations nodes using this specification
https://facebook.github.io/graphql/draft/#sec-Validation.Operations
"
Class {
	#name : #GQLOperationsVisitor,
	#superclass : #GQLNodeVisitor,
	#category : #'GraphQLBeta-Visitors'
}

{ #category : #visiting }
GQLOperationsVisitor >> visitDocumentNode: node [
	| ocurrences |
	ocurrences := node operations groupedBy: [ :op | 
		op class = GQLOperationNode
			ifTrue: [ op name ]
			ifFalse: [ '' ]  ].
	
	((ocurrences includesKey: '') and: [ ocurrences size > 1 ]) ifTrue: [ 
		self
			addErrorMessage: 'GraphQL allows a short‐hand form for defining query operations when only that one operation exists in the document.' 
			nodes: (ocurrences at: '')].
	ocurrences keysAndValuesDo: [ :k :list |
		(list size > 1 and: [ k ~= '' ]) ifTrue: [ 
			self
				addErrorMessage: 'Each named operation definition must be unique: "', k, '"'
				nodes: list ] ].
]
