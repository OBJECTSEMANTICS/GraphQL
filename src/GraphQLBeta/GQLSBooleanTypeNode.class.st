"
I represent a boolean type.
"
Class {
	#name : #GQLSBooleanTypeNode,
	#superclass : #GQLSScalarTypeNode,
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #testing }
GQLSBooleanTypeNode >> basicCoerce: value on: schema [
	^ value class = GQLBooleanNode
]

{ #category : #initialization }
GQLSBooleanTypeNode >> initialize [
	super initialize.
	name := 'Boolean'
]
