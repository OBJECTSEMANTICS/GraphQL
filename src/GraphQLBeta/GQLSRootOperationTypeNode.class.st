"
I represent a root operation of a schema definition. My root operation types only could be: query, mutation and/or subscription.
"
Class {
	#name : #GQLSRootOperationTypeNode,
	#superclass : #GQLSNode,
	#instVars : [
		'name',
		'key'
	],
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #adding }
GQLSRootOperationTypeNode >> executeBlock: aBlock [
	^ aBlock value: key
	
]

{ #category : #accessing }
GQLSRootOperationTypeNode >> key: aString [
	key := aString 
]

{ #category : #accessing }
GQLSRootOperationTypeNode >> name [
	^ name
]

{ #category : #accessing }
GQLSRootOperationTypeNode >> name: aName [
	name := aName 
]
