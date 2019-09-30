"
I represent a fragment spread on a request.

Public API and Key Messages

- name

    Instance Variables
	name:		<String>


    Implementation Points
"
Class {
	#name : #GQLFragmentSpreadNode,
	#superclass : #GQLSelectionNode,
	#instVars : [
		'name'
	],
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #comparing }
GQLFragmentSpreadNode >> = other [
	
	^ self name = other name
]

{ #category : #visiting }
GQLFragmentSpreadNode >> accept: visitor [
	visitor visitFragmentSpreadNode: self
]

{ #category : #'as yet unclassified' }
GQLFragmentSpreadNode >> collectVariablesOn: context with: visitedFragments [
	| groupedVariables |
	groupedVariables := Set new.
	(visitedFragments includes: name) 
	ifFalse: [ 
		visitedFragments add: name.
		groupedVariables addAll: (
		self collectVarSelectionSet: (context fragments at: name) selectionSet 
		using: context with: visitedFragments).
		 ].
	^ groupedVariables
]

{ #category : #comparing }
GQLFragmentSpreadNode >> hash [

	^ self name hash
]

{ #category : #utils }
GQLFragmentSpreadNode >> ifField: aFieldBlock ifFragment: aFragmentBlock ifInline: aInlineBlock [

	^ aFragmentBlock value
]

{ #category : #testing }
GQLFragmentSpreadNode >> isSpread [

	^ true
]

{ #category : #accessing }
GQLFragmentSpreadNode >> name [
"Return the name"
	^ name
]

{ #category : #accessing }
GQLFragmentSpreadNode >> name: anObject [
"Set the name"
	name := anObject
]

{ #category : #accessing }
GQLFragmentSpreadNode >> targetSpreads [
"Return an array with self"
	^ Array with: self.
]
