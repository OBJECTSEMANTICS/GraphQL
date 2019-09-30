"
I represent an operation node of a request.

Public API and Key Messages

- directives
- name
- selectionSet
- type
- variableDefinitions

    Instance Variables
	directives:		<Array>
	name:		<String>
	selectionSet:		<GQLSelectionSetNode>
	type:		<GQLSTypeNode>
	variableDefinitions:		<Array>


    Implementation Points
"
Class {
	#name : #GQLOperationNode,
	#superclass : #GQLOperationDefinitionNode,
	#instVars : [
		'type',
		'name',
		'variableDefinitions',
		'directives',
		'selectionSet',
		'rootInstance'
	],
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #accessing }
GQLOperationNode class >> nodeName [
	^ 'QUERY'
]

{ #category : #visiting }
GQLOperationNode >> accept: visitor [
	visitor visitOperationNode: self
]

{ #category : #action }
GQLOperationNode >> collectVariables: context [
	"Collect all variables"
	| groupedVariables visitedFragments selections |
	groupedVariables := Set new.
	visitedFragments := Set new.
	selections := self selectionSet selections.
	selections do: [ :selection | groupedVariables addAll: (selection collectVariablesOn: context with: visitedFragments) ].
	^ groupedVariables
]

{ #category : #accessing }
GQLOperationNode >> directives [
"Return the directives"
	^ directives ifNil: [ #() ]
]

{ #category : #accessing }
GQLOperationNode >> directives: anObject [
"Set the directives"
	directives := anObject
]

{ #category : #action }
GQLOperationNode >> executeOn: root with: context using: schema [
		"Execute the operation with the root, an enviroment and the schema"
	| response |
	response := OrderedDictionary new.
	response addAll: (self selectionSet executeOn: (self rootOperation: root) with: context using: schema).
	^ response
]

{ #category : #accessing }
GQLOperationNode >> name [
"Return the name"
	^ name
]

{ #category : #accessing }
GQLOperationNode >> name: aName [
"Set the name"
	aName ifNotNil: [ name := aName inputValue ]
]

{ #category : #accessing }
GQLOperationNode >> selectionSet [
"Return the selection set"
	^ selectionSet
]

{ #category : #accessing }
GQLOperationNode >> selectionSet: anObject [
"Set the selection set"
	selectionSet := anObject
]

{ #category : #accessing }
GQLOperationNode >> targetSpreads [
"Return the names of fragment spreads used"
	^ selectionSet targetSpreads
]

{ #category : #accessing }
GQLOperationNode >> type [
"Return the type"
	^ type
]

{ #category : #accessing }
GQLOperationNode >> type: anObject [
"Set the type"
	type := anObject
]

{ #category : #action }
GQLOperationNode >> unrepeatedVariables: aCollection [
	^ (aCollection collect: [ :var | var name value ]) asSet size = aCollection size.
]

{ #category : #'as yet unclassified' }
GQLOperationNode >> validVariables [
	| variables |
	variables := OrderedCollection new.
	variableDefinitions isNotNil
	ifTrue: [		
		variables := variableDefinitions.
		(self unrepeatedVariables: variables) 
		ifFalse: [ variables := OrderedCollection new ]
	].
	^ variables.
]

{ #category : #accessing }
GQLOperationNode >> variableDefinitions [
"Return the variable definitions"
	^ variableDefinitions ifNil: [ #() ].
]

{ #category : #accessing }
GQLOperationNode >> variableDefinitions: anObject [
"Set the variable definitions"
	variableDefinitions := anObject
]
