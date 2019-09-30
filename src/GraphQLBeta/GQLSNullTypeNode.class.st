"
I am null type for validation propouses
"
Class {
	#name : #GQLSNullTypeNode,
	#superclass : #GQLSTypeNode,
	#classInstVars : [
		'instance'
	],
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #accessing }
GQLSNullTypeNode class >> instance [
	^ instance ifNil: [ instance := self new ].
]

{ #category : #accessing }
GQLSNullTypeNode >> getField: string [
	^ self
]

{ #category : #accessing }
GQLSNullTypeNode >> isNullType [
	^ true
]

{ #category : #accessing }
GQLSNullTypeNode >> rawType: schema [
	^ self
]

{ #category : #accessing }
GQLSNullTypeNode >> type [
	^ self
]
