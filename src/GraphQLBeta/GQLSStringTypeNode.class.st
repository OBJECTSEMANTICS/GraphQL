"
I represent a string type.
"
Class {
	#name : #GQLSStringTypeNode,
	#superclass : #GQLSScalarTypeNode,
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #testing }
GQLSStringTypeNode >> basicCoerce: value on: schema [
	^ value class = GQLStringNode 
]

{ #category : #initialization }
GQLSStringTypeNode >> initialize [
	super initialize.
	name := 'String'
]
