"
I represent a abstract node of a graphql request 

Public API and Key Messages

-  position:

To see more information go to the subclasses
"
Class {
	#name : #GQLAbstractNode,
	#superclass : #GraphQLObject,
	#instVars : [
		'position'
	],
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #initialization }
GQLAbstractNode >> initialize [

	position := 0.
]

{ #category : #accessing }
GQLAbstractNode >> position [
	^ position
]

{ #category : #accessing }
GQLAbstractNode >> position: anObject [
	position := anObject
]
