"
I represent an inline fragment on a request.

Public API and Key Messages

- selectionSet
- typeCondition

    Instance Variables
	selectionSet:		<GQLSelectionSetNode>
	typeCondition:		<GQLSTypeNode>


    Implementation Points
"
Class {
	#name : #GQLInlineFragmentNode,
	#superclass : #GQLSelectionNode,
	#instVars : [
		'typeCondition',
		'selectionSet'
	],
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #visiting }
GQLInlineFragmentNode >> accept: visitor [
	visitor visitInlineFragmentNode: self
]

{ #category : #utils }
GQLInlineFragmentNode >> collectVariablesOn: context with: visitedFragments [
	"Collect variables of inline fragments based on their selection set"
	^ self collectVarSelectionSet: selectionSet using: context with: visitedFragments.	
]

{ #category : #utils }
GQLInlineFragmentNode >> ifField: aFieldBlock ifFragment: aFragmentBlock ifInline: aInlineBlock [

	^ aInlineBlock value
]

{ #category : #accessing }
GQLInlineFragmentNode >> selectionSet [
"Return the selection set"
	^ selectionSet
]

{ #category : #accessing }
GQLInlineFragmentNode >> selectionSet: anObject [
"Set the selection set"
	selectionSet := anObject
]

{ #category : #accessing }
GQLInlineFragmentNode >> targetSpreads [
"Return the fragment spreads used on the selection set"
	^ selectionSet targetSpreads
]

{ #category : #accessing }
GQLInlineFragmentNode >> typeCondition [
"Return the type condition"
	^ typeCondition
]

{ #category : #accessing }
GQLInlineFragmentNode >> typeCondition: anObject [
"Set the type condition"
	typeCondition := anObject
]
