"
I represent a definition on the request.

For more information see my subclasses.
"
Class {
	#name : #GQLDefinitionNode,
	#superclass : #GQLNode,
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #testing }
GQLDefinitionNode >> isOperation [
	^ self subclassResponsibility 
]
