"
I represent a non null type.
"
Class {
	#name : #GQLSNonNullTypeNode,
	#superclass : #GQLSWrapTypeNode,
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #testing }
GQLSNonNullTypeNode >> canCoerce: value on: schema [
	^ value class = GQLNullNode 
		ifTrue: [ ^ false ]
		ifFalse: [ wrappedType canCoerce: value on: schema ] 
]

{ #category : #coercion }
GQLSNonNullTypeNode >> coerceValue: value on: schema [
	^ self wrappedType coerceValue: value on: schema.
]

{ #category : #accessing }
GQLSNonNullTypeNode >> kind [
	^ 'NON_NULL'
]

{ #category : #accessing }
GQLSNonNullTypeNode >> name [ 
	^ nil
]

{ #category : #printing }
GQLSNonNullTypeNode >> printOn: stream [
	self wrappedType printOn: stream.
	stream nextPutAll: '!'.
]
