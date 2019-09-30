"
I represent the definition of an operation on the request.

To more information see my subclasses.
"
Class {
	#name : #GQLOperationDefinitionNode,
	#superclass : #GQLDefinitionNode,
	#classInstVars : [
		'dictIntrospectionTypes'
	],
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #testing }
GQLOperationDefinitionNode >> isOperation [

	^ true
]

{ #category : #accessing }
GQLOperationDefinitionNode >> rootOperation: root [

	^ root isDictionary 
		ifTrue: [ root at: self type ] 
		ifFalse: [ root ].
]

{ #category : #accessing }
GQLOperationDefinitionNode >> targetSpreads [
	^ self subclassResponsibility
]

{ #category : #accessing }
GQLOperationDefinitionNode >> type [

	^ self subclassResponsibility 
]
