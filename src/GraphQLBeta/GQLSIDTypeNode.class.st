"
I represent a id type.
"
Class {
	#name : #GQLSIDTypeNode,
	#superclass : #GQLSScalarTypeNode,
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #testing }
GQLSIDTypeNode >> basicCoerce: value on: schema [
	^ value class = GQLStringNode or: [ value class = GQLIntNode ]
]

{ #category : #initialization }
GQLSIDTypeNode >> initialize [
	super initialize.
	name := 'ID'
]
