"
I represent a object value. I'm a complex value, so I have object fields, like:

{ name : ""Juan"", lastName : ""Fernandez"" }

Public API and Key Messages

- objectFields

    Instance Variables
	objectFields:		<Array>


    Implementation Points
"
Class {
	#name : #GQLObjectNode,
	#superclass : #GQLValueNode,
	#instVars : [
		'objectFields'
	],
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #action }
GQLObjectNode >> executeOn: resolver with: context using: schema [
"Return the object with its respective fields"
	| objectResult |
	objectResult := resolver class new.
	objectFields do: [ :objField | 
		objectResult := objectResult perform: (objField name, ':') asSymbol 
											with: (objField executeOn: resolver with: context using: schema)].
	^ objectResult 
]

{ #category : #testing }
GQLObjectNode >> isObjectNode [
	^ true
]

{ #category : #accessing }
GQLObjectNode >> name: aName using: schema [
	(aName endsWith: 'Input') 
	ifTrue: [ ^ aName copyFrom: 1 to: aName size - 5 ]
	ifFalse: [ ^ aName ].
]

{ #category : #accessing }
GQLObjectNode >> objectFields [
"Return the object fields"
	^ objectFields
]

{ #category : #accessing }
GQLObjectNode >> objectFields: anObject [
"Set the object fields"
	objectFields := anObject.
	objectFields isEmpty ifTrue: [ ^ GQLException new messageText: 'objectFields empty'; raise] 
								ifFalse: [ self position: objectFields first position ]
]

{ #category : #printing }
GQLObjectNode >> printOn: stream [
	stream nextPutAll: '{'.
	self objectFields 
		do: [ :field | field printOn: stream ]
		separatedBy: [ stream nextPutAll: ', '].
	stream nextPutAll: '}'.
]

{ #category : #accessing }
GQLObjectNode >> valueVariables [
	| valueVariables |
	valueVariables := Dictionary new.
	self objectFields select: [ :objField | objField value isVariableNode ] 
	thenDo: [ :objField | valueVariables at: objField value value put: objField value ].
	^ valueVariables
]
