"
I represent a skip directive, my argument is only one of name 'if' and type Boolean.

Public API and Key Messages

- condition
- isSkip
"
Class {
	#name : #GQLSkipDirectiveNode,
	#superclass : #GQLDefaultDirectiveNode,
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #'as yet unclassified' }
GQLSkipDirectiveNode class >> directiveName [

	^ 'skip'
]

{ #category : #accessing }
GQLSkipDirectiveNode >> condition [
"Return the condition that must have to able the field"
	^ 'false'.
]

{ #category : #initialization }
GQLSkipDirectiveNode >> initialize [

	super initialize.
	name := 'skip'.
]

{ #category : #accessing }
GQLSkipDirectiveNode >> isSkip [

	^ true
]
