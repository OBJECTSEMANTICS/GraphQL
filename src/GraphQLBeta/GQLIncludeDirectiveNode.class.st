"
I represent an include directive, my argument is only one of name 'if' and type Boolean.

Public API and Key Messages

- condition
- isInclude
"
Class {
	#name : #GQLIncludeDirectiveNode,
	#superclass : #GQLDefaultDirectiveNode,
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #'as yet unclassified' }
GQLIncludeDirectiveNode class >> directiveName [

	^ 'include'
]

{ #category : #accessing }
GQLIncludeDirectiveNode >> condition [
"Return the condition that must have to able the field"
	^ 'true'.
]

{ #category : #initialization }
GQLIncludeDirectiveNode >> initialize [

	super initialize.
	name := 'include'.
]

{ #category : #accessing }
GQLIncludeDirectiveNode >> isInclude [

	^ true
]
