"
I represent a selection set on a request.

Public API and Key Messages

- selections
- collectFields
- mergeSelectionSet:with:

    Instance Variables
	selections:		<Array>


    Implementation Points
"
Class {
	#name : #GQLSelectionSetNode,
	#superclass : #GQLOperationDefinitionNode,
	#instVars : [
		'selections'
	],
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #action }
GQLSelectionSetNode >> collectField: selection with: groupedFields [
"View on groupedFields if selection exist or if can merge"	
	| responseKey |
	responseKey := selection key.
	(groupedFields includesKey: responseKey)
				ifTrue: [ 
					(self sameShape: (groupedFields at: responseKey) with: selection)
					ifTrue: [ selection isScalar 
						ifFalse: [ 
								self
								mergeSelectionSet: (groupedFields at: responseKey)
								with: selection ] ]
					ifFalse: [ ^ GQLException new node: selection; 
							messageText: 'Duplicated fields with different arguments, use alias';
							raise ].	
						 ]
				ifFalse:
					[ groupedFields at: responseKey put: selection ].
		^ groupedFields
]

{ #category : #action }
GQLSelectionSetNode >> collectFields: context [
	"Collect all the selections"
	| groupedFields visitedFragments |
	groupedFields := OrderedDictionary new.
	visitedFragments := OrderedDictionary new.
	selections select: [ :field | field executeDirectives: context ]
		thenDo: [ :selection |
			groupedFields := 
				selection ifField: [ self collectField: selection with: groupedFields. ]
						 ifFragment:  [ 
							self collectFragment: selection 
										with: visitedFragments using: groupedFields on: context ]
						 ifInline: [ self collectInlineFragment: selection with: groupedFields on: context ].
				 ].
	^ groupedFields
]

{ #category : #action }
GQLSelectionSetNode >> collectFragment: selection with: visitedFragments using: groupedFields on: context [
"View on visitedFragments if fragment exist, then add selectionSet based on groupedFields
HERE IS IMPORTANT VERIFY THE TYPE"	
	| responseKey fragment fragmentFieldSet |
	responseKey := selection name.
	(visitedFragments includesKey: responseKey) ifFalse: [ 
		visitedFragments at: responseKey put: selection.
		context fragments 
			at: responseKey
			ifPresent: [ :v | fragment := v ]
			ifAbsent: [ ^ GQLException new 
					node: selection;
					messageText: 'Undefined fragment';
					raise ].
		fragmentFieldSet := fragment selectionSet collectFields: context.
		fragmentFieldSet valuesDo: [ :value |
			self collectField: value with: groupedFields ]
		].
		^ groupedFields
]

{ #category : #'as yet unclassified' }
GQLSelectionSetNode >> collectFragmentNameFields: selection with: schemaTypes root: aString using: visitedFragments and: dictNameFields on: context [
	| responseKey fragment |
	responseKey := selection name.
	(visitedFragments includesKey: responseKey) ifFalse: [
		visitedFragments at: responseKey put: selection.
		fragment := context fragments at: responseKey.
		fragment selectionSet collectNameFieldsToAvoid: schemaTypes root: aString  with: context and: dictNameFields.
	].
	^ dictNameFields 
]

{ #category : #action }
GQLSelectionSetNode >> collectInlineFragment: selection with: groupedFields on: context [
"Collect inline fragments based on their selection set
HERE TYPE CHECK THE TYPE OF INLINE FRAGMENT"	
	| fragmentFieldSet |
	fragmentFieldSet := selection selectionSet collectFields: context.
	fragmentFieldSet valuesDo: [ :value |
	self collectField: value with: groupedFields ].
	^ groupedFields
]

{ #category : #'as yet unclassified' }
GQLSelectionSetNode >> collectInlineNameFields: selection with: schemaTypes root: aString and: dictNameFields [
	selection typeCondition ifNotNil: [
		(self fieldToExecute: selection typeCondition name with: aString using: schemaTypes)
		ifTrue: [ (dictNameFields at: 'nameFieldsToExecute') addAll: (selection selectionSet selections 
			collect: [ :sel | sel name ]) ]
		ifFalse: [ (dictNameFields at: 'nameFieldsToAvoid') addAll: (selection selectionSet selections collect: [:sel | sel name])]
	].
	^ dictNameFields 
]

{ #category : #'as yet unclassified' }
GQLSelectionSetNode >> collectNameFieldsToAvoid: schemaTypes root: aString with: context and: dictNameFields [
	| visitedFragments nameFieldsToExecute copyDictNameFields |
	copyDictNameFields := dictNameFields deepCopy.
	visitedFragments := OrderedDictionary new.
	selections select: [ :field | field executeDirectives: context ]
	thenDo: [ :selection |
		copyDictNameFields := 	
			selection ifField: [ dictNameFields ] 
			ifFragment: [ self collectFragmentNameFields: selection with: schemaTypes root: aString using: visitedFragments and: dictNameFields on: context ] 
			ifInline: [ self collectInlineNameFields: selection with: schemaTypes root: aString and: dictNameFields ]
	].
	nameFieldsToExecute := copyDictNameFields at: 'nameFieldsToExecute'.
	^ (copyDictNameFields at: 'nameFieldsToAvoid') reject: [ :aName | nameFieldsToExecute includes: aName ]
]

{ #category : #'as yet unclassified' }
GQLSelectionSetNode >> collectNameFieldsToAvoid: schemaTypes with: aString and: context [
	| dictNameFields |
	dictNameFields := Dictionary new 
	at: 'nameFieldsToAvoid' put: OrderedCollection new;
	at: 'nameFieldsToExecute' put: OrderedCollection new; yourself.
	^ self collectNameFieldsToAvoid: schemaTypes root: aString  with: context and: dictNameFields
]

{ #category : #action }
GQLSelectionSetNode >> executeOn: root with: context using: schema [
	"Execute the field nodes with the root, an enviroment and the schema"

	| collectedFields response myRoot |
	selections detect: [ :selection | (selection evaluateDirectives: schema using: context) not ]
				ifFound: [ :selection | ^ GQLException new node: selection; 
									messageText: 'Error on directives'; raise ].
	collectedFields := self collectFields: context.
	collectedFields class = GQLException ifTrue: [ ^ collectedFields ].
	myRoot := self rootOperation: root.
	((myRoot isKindOf: GQLSNamedTypeNode))
	ifTrue: [ myRoot:= schema getType: myRoot name ].
	myRoot isNotNil ifTrue: [ 
		| nameFieldsToAvoid |
		response := OrderedDictionary new.
		nameFieldsToAvoid := self collectNameFieldsToAvoid: schema schemaTypes with: myRoot className asString and: context.
	collectedFields
		do: [ :f |
			(nameFieldsToAvoid includes: f key) ifFalse: [ 
			response
				at: f key
				put: (f executeOn: myRoot with: context using: schema). ]
			]
	].
	^ response
]

{ #category : #'as yet unclassified' }
GQLSelectionSetNode >> fieldToExecute: aNameType with: aNameRoot using: schemaTypes [
	^ aNameType = aNameRoot ifFalse: [ 
		| aType |
		aType := schemaTypes at: aNameType.
		(aType isInterfaceType and: [ (aType implementors collect: [ :impl | impl name ]) includes: aNameRoot ]) 
	] ifTrue: [ 
		true
	]
]

{ #category : #action }
GQLSelectionSetNode >> mergeSelectionSet: field1 with: field2 [
"Merge two selection sets"

	| newFieldNodes |
	newFieldNodes := OrderedCollection new.
	newFieldNodes addAll: (field2 selectionSet selections).
	newFieldNodes addAll: (field1 selectionSet selections).
	field1 selectionSet selections: newFieldNodes asArray
]

{ #category : #action }
GQLSelectionSetNode >> sameShape: field1 with: field2 [
"Verify if two fields have the same name and value arguments
HERE IS IMPORTANT VERIFY THE TYPE"

	^ (field1 name = field2 name) and: [ field1 arguments = field2 arguments ]
]

{ #category : #accessing }
GQLSelectionSetNode >> selections [
"Return the selections"
	^ selections
]

{ #category : #accessing }
GQLSelectionSetNode >> selections: fields [
"Set the selections"
	selections := fields
]

{ #category : #accessing }
GQLSelectionSetNode >> targetSpreads [
"Return all the fragments spreads used on this node"
	| spreads |
	spreads := Set new.
	selections do: [ :selection | spreads addAll: selection targetSpreads ].
	^ spreads
]

{ #category : #action }
GQLSelectionSetNode >> type [

	^ 'query'
]
