"
I represent a fragment on the request.

Public API and Key Messages

- directives
- name
- selectionSet
- typeCondition


    Instance Variables
	directives:		<Array>
	name:		<String>
	selectionSet:		<GQLSelectionSetNode>
	typeCondition:		<GQLSTypeNode>

"
Class {
	#name : #GQLFragmentNode,
	#superclass : #GQLDefinitionNode,
	#instVars : [
		'name',
		'typeCondition',
		'directives',
		'selectionSet',
		'hasCycle'
	],
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #visiting }
GQLFragmentNode >> accept: visitor [
	visitor visitFragmentNode: self.
]

{ #category : #accessing }
GQLFragmentNode >> directives [
"Return the directives"
	^ directives ifNil: [ #() ] 
]

{ #category : #accessing }
GQLFragmentNode >> directives: anObject [
"Set the directives"
	directives := anObject
]

{ #category : #testing }
GQLFragmentNode >> hasCycle: aDocument [
	^ hasCycle ifNil: [ 
		hasCycle := aDocument hasCycle: self with: Set new ].
]

{ #category : #testing }
GQLFragmentNode >> isOperation [

	^ false
]

{ #category : #accessing }
GQLFragmentNode >> name [
"Return the name"
	^ name
]

{ #category : #accessing }
GQLFragmentNode >> name: anObject [
"Set the name"
	name := anObject
]

{ #category : #accessing }
GQLFragmentNode >> selectionSet [
"Return the selection set"
	^ selectionSet
]

{ #category : #accessing }
GQLFragmentNode >> selectionSet: anObject [
"Set the selection set"
	selectionSet := anObject
]

{ #category : #accessing }
GQLFragmentNode >> setHasCycle: bool [
	hasCycle := bool.
]

{ #category : #accessing }
GQLFragmentNode >> targetSpreads [
"Return the fragment spreads of this node"
	^ selectionSet targetSpreads
]

{ #category : #accessing }
GQLFragmentNode >> typeCondition [
"Return the type condition"
	^ typeCondition
]

{ #category : #accessing }
GQLFragmentNode >> typeCondition: anObject [
"Set the type condition"
	typeCondition := anObject
]
