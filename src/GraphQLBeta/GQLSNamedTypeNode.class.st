"
I represent a named type. 

Public API and Key Messages

- name
- name:

    Instance Variables
	name:		<String>

"
Class {
	#name : #GQLSNamedTypeNode,
	#superclass : #GQLSTypeNode,
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #testing }
GQLSNamedTypeNode >> basicCoerce: value on: schema [
	| type |
	type := schema getType: self name.
	type = self ifTrue: [ self error: 'Override canCoerce in this class'].
	^ type canCoerce: value on: schema
]

{ #category : #coercion }
GQLSNamedTypeNode >> coerceValue: value on: schema [
	| type |
	schema ifNil: [ ^ super coerceValue: value on: schema ].
	type := schema getType: self name.
	type = self ifTrue: [ ^ super coerceValue: value on: schema ].
	^ type coerceValue: value on: schema
]

{ #category : #testing }
GQLSNamedTypeNode >> isObjectInputType: schema [
	| type |
	type := schema getType: self name.
	^ type class = GQLSInputObjectTypeNode 
]

{ #category : #accessing }
GQLSNamedTypeNode >> nameOfClass: aName [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
GQLSNamedTypeNode >> ofType [
	^ nil
]

{ #category : #printing }
GQLSNamedTypeNode >> printOn: stream [
	stream nextPutAll: name
]

{ #category : #accessing }
GQLSNamedTypeNode >> rawType: schema [
	^ schema getType: name.
]

{ #category : #'as yet unclassified' }
GQLSNamedTypeNode >> verifyAndInclude: otherNamedType  with: resolvers [
	^ self subclassResponsibility 
]
