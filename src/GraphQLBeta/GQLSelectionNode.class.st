"
I represent a selection on a request.

Public API and Key Messages

- directives

    Instance Variables
	directives:		<Array>


    Implementation Points
"
Class {
	#name : #GQLSelectionNode,
	#superclass : #GQLNode,
	#instVars : [
		'directives'
	],
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #'as yet unclassified' }
GQLSelectionNode >> collectVarSelectionSet: aSelectionSet using: context with: visitedFragments [
	| groupedVariables |
	groupedVariables := Set new.
	aSelectionSet selections do: [ :selection | 
		groupedVariables addAll: (selection collectVariablesOn: context with: visitedFragments)
	].
	^ groupedVariables 
]

{ #category : #'as yet unclassified' }
GQLSelectionNode >> collectVariablesOn: context with: visitedFragments [
	^ self subclassResponsibility 
]

{ #category : #accessing }
GQLSelectionNode >> directives [
"Return the directives"
	^ directives ifNil: [ #() ]
]

{ #category : #accessing }
GQLSelectionNode >> directives: anObject [
"Set the directives"
	directives := anObject
]

{ #category : #accessing }
GQLSelectionNode >> evaluateDirectives: schema using: context [
"Verify that directives follow the specification of the schema directives"
	directives ifNil: [ ^ true ]. 
	((directives select: #isSkip) size <= 1) & ((directives select: #isInclude) size <= 1)
		ifTrue: [ ^ directives allSatisfy: [ :directive | 
					(directive evaluateOn: schema using: context) ] ]
		ifFalse: [ ^ false ].
]

{ #category : #action }
GQLSelectionNode >> executeDirectives: context [
	"Execute the directives based on the variables declared on context or their arguments"
	| executedDirectives |
	directives ifNil: [ ^ true ].
	^ directives allSatisfy: [ :dir | dir execute: context ].
]

{ #category : #utils }
GQLSelectionNode >> ifField: aFieldBlock ifFragment: aFragmentBlock ifInline: aInlineBlock [

	^ self subclassResponsibility 
]

{ #category : #testing }
GQLSelectionNode >> isSpread [

	^ false
]
