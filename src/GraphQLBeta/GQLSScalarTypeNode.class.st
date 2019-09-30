"
I represent a scalar type.

Public API and Key Messages

- isInputType

For more information see my subclasses.
"
Class {
	#name : #GQLSScalarTypeNode,
	#superclass : #GQLSNamedTypeNode,
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #testing }
GQLSScalarTypeNode >> isInputType [
"Return if is a input type"
	^ true
]

{ #category : #testing }
GQLSScalarTypeNode >> isScalarType [
"Return if is a scalar type"
	^ true
]

{ #category : #accessing }
GQLSScalarTypeNode >> kind [
	^ 'SCALAR'
]

{ #category : #printing }
GQLSScalarTypeNode >> printFullOn: stream [
	stream
		nextPutAll: 'scalar ';
		nextPutAll: self name.
]
