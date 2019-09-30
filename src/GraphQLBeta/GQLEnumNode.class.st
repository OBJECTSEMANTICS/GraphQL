"
I represent a enum value on the request.

"
Class {
	#name : #GQLEnumNode,
	#superclass : #GQLValueNode,
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #action }
GQLEnumNode >> executeOn: aGQLEnumNode with: aGQLContext using: aGQLSSchemaNode [ 
	^ value
]

{ #category : #accessing }
GQLEnumNode >> name: aName using: schema [
	^ self class name
]

{ #category : #printing }
GQLEnumNode >> printOn: stream [
	stream nextPutAll: value
]
