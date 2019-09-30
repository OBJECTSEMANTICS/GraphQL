"
I represent a wrap type. 

Public API and Key Messages

- wrappedType
- wrappedType:

    Instance Variables
	wrappedType:		<GQLSTypeNode>

"
Class {
	#name : #GQLSWrapTypeNode,
	#superclass : #GQLSTypeNode,
	#instVars : [
		'wrappedType'
	],
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #testing }
GQLSWrapTypeNode >> isInputType [
"Return if the wrappedType is a inputType"
	^ self wrappedType isInputType 
]

{ #category : #testing }
GQLSWrapTypeNode >> isObjectInputType: schema [
	^ self wrappedType isObjectInputType: schema
]

{ #category : #testing }
GQLSWrapTypeNode >> isWrappedType [
"Return if has a wrapped type"
	^ true
]

{ #category : #accessing }
GQLSWrapTypeNode >> name [
	^ self wrappedType name
]

{ #category : #'as yet unclassified' }
GQLSWrapTypeNode >> ofType [
	^ self wrappedType.
]

{ #category : #accessing }
GQLSWrapTypeNode >> rawType: schema [
	^ self wrappedType rawType: schema.
]

{ #category : #accessing }
GQLSWrapTypeNode >> wrappedType [
"Return the wrappedType"
	^ wrappedType 
]

{ #category : #accessing }
GQLSWrapTypeNode >> wrappedType: aType [
"Set the wrappedType"
	wrappedType := aType
]
