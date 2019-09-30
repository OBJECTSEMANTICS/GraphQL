"
I repreent a directive on the schema

Public API and Key Messages 
- arguments
- name 
- directiveLocations
"
Class {
	#name : #GQLSDirectiveNode,
	#superclass : #GQLSNode,
	#instVars : [
		'name',
		'arguments',
		'directiveLocations'
	],
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #accessing }
GQLSDirectiveNode >> args [
	^ arguments
]

{ #category : #accessing }
GQLSDirectiveNode >> arguments [
	^ arguments
]

{ #category : #accessing }
GQLSDirectiveNode >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
GQLSDirectiveNode >> directiveLocations [
	^ directiveLocations
]

{ #category : #accessing }
GQLSDirectiveNode >> directiveLocations: anObject [
	directiveLocations := anObject
]

{ #category : #accessing }
GQLSDirectiveNode >> locations [
	^ #('FIELD' 'FRAGMENT_SPREAD' 'INLINE_FRAGMENT')
]

{ #category : #accessing }
GQLSDirectiveNode >> name [
	^ name
]

{ #category : #accessing }
GQLSDirectiveNode >> name: anObject [
	name := anObject
]
