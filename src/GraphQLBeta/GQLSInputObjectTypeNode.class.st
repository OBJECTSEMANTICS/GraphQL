"
I represent a input object type. I'm a input type, used as type of an argument.

Public API and Key Messages

- addFields:
- getField:


    Instance Variables
	fieldSet:		<Dictionary>


    Implementation Points
"
Class {
	#name : #GQLSInputObjectTypeNode,
	#superclass : #GQLSNamedTypeNode,
	#instVars : [
		'fieldSet'
	],
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #adding }
GQLSInputObjectTypeNode >> addFields: aArray [
"Given a collection puts the values on a dictionary for improve the search"
	aArray do: [ :field | fieldSet at: field name put: field ]
]

{ #category : #testing }
GQLSInputObjectTypeNode >> basicCoerce: value on: schema [
	^ value class = GQLObjectNode 
]

{ #category : #coercion }
GQLSInputObjectTypeNode >> coerceValue: value on: schema [
	value isVariableNode ifTrue: [ ^ value ].
	value class = GQLNullNode ifTrue: [ ^ value ].
	value class = GQLObjectNode ifFalse: [ self error: 'invalid input' ].
	^ value
]

{ #category : #accessing }
GQLSInputObjectTypeNode >> fields [
	^ fieldSet 
]

{ #category : #accessing }
GQLSInputObjectTypeNode >> getField: aFieldName [
	"Return the field given his name"

	| res |
	res := (fieldSet includesKey: aFieldName)
		ifTrue: [ fieldSet at: aFieldName ]
		ifFalse: [ nil ].
	^ res
]

{ #category : #initialization }
GQLSInputObjectTypeNode >> initialize [
	super initialize.
	fieldSet := Dictionary new
]

{ #category : #'as yet unclassified' }
GQLSInputObjectTypeNode >> inputFields [
	^ self fields
]

{ #category : #testing }
GQLSInputObjectTypeNode >> isInputType [
"Return if if a input type"
	^ true
]

{ #category : #testing }
GQLSInputObjectTypeNode >> isValidateClass [
"Respondes if a type needs to be searched on the image of Pharo"

	^ true
]

{ #category : #accessing }
GQLSInputObjectTypeNode >> kind [
	^ 'INPUT_OBJECT'
]

{ #category : #accessing }
GQLSInputObjectTypeNode >> nameOfClass: aName [
	(aName endsWith: 'Input') 
	ifTrue: [ ^ aName copyFrom: 1 to: aName size - 5 ]
	ifFalse: [ ^ GQLException new node: self; 
					messageText: 'Error with variables'; raise ].
]

{ #category : #printing }
GQLSInputObjectTypeNode >> printFullOn: stream [
	stream 
		nextPutAll: 'input ';
		nextPutAll: self name.
	stream nextPutAll: '{'; cr.
	self fields 
		do: [ :field | 
			stream tab.
			field printFullOn: stream ] 
		separatedBy: [ stream cr ].
	stream cr; nextPutAll: '}'.
]

{ #category : #'as yet unclassified' }
GQLSInputObjectTypeNode >> verifyAndInclude: otherNamedType  with: resolvers [
	(otherNamedType class = self class and: 
	[ (fieldSet keys includesAny: otherNamedType fields keys) not ])
	ifTrue: [ fieldSet addAll: otherNamedType fields ]
	ifFalse: [ ^ GQLValidationException new node: otherNamedType;
													messageText: 'The namedType is not InputObject type or its fields already have been defined'; raise  ]
]
