"
I represent a abstract node generated with the description

Public API and Key Messages

- position
- position:

    Instance Variables
	position:		<Integer>

"
Class {
	#name : #GQLSAbstractNode,
	#superclass : #GraphQLObject,
	#instVars : [
		'position'
	],
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #initialization }
GQLSAbstractNode >> initialize [
"The default position is 0"
	position := 0.
]

{ #category : #accessing }
GQLSAbstractNode >> position [
	^ position
]

{ #category : #accessing }
GQLSAbstractNode >> position: anObject [
	position := anObject
]
