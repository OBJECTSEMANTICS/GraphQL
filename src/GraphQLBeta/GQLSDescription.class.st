"
I represent an description of a schema node, like:
value : String

Public API and Key Messages

- value
- value: 


    Instance Variables
	value:		<String>

"
Class {
	#name : #GQLSDescription,
	#superclass : #GQLSAbstractNode,
	#instVars : [
		'value'
	],
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #accessing }
GQLSDescription >> value [ 
	"return the value"
	^ value
]

{ #category : #accessing }
GQLSDescription >> value: anObject [
	value := anObject
]
