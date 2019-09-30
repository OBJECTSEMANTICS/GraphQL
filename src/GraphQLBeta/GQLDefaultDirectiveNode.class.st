"
I represent an default directive defined by GraphQL specifications.

Public API and Key Messages

- execute
"
Class {
	#name : #GQLDefaultDirectiveNode,
	#superclass : #GQLDirectiveNode,
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #'as yet unclassified' }
GQLDefaultDirectiveNode class >> directiveName [
	^ ''
]

{ #category : #accessing }
GQLDefaultDirectiveNode >> condition [
	^ self subclassResponsibility
]

{ #category : #execute }
GQLDefaultDirectiveNode >> execute: context [
	
	| node |
	node := self arguments first value.
	^ node value = self condition or: [(node valueWith: context) = self condition]
]

{ #category : #initialization }
GQLDefaultDirectiveNode >> initialize [
	super initialize.
	arguments := Array with: (GQLArgumentNode new name: 'if'; 
											   value: GQLBooleanNode new).
]
