"
I represent a interface type. I have fields.

Public API and Key Messages

- addFields:
- fields
- getField:

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	fields:		<Object>


    Implementation Points
"
Class {
	#name : #GQLSInterfaceTypeNode,
	#superclass : #GQLSNamedTypeNode,
	#instVars : [
		'fields',
		'implementors'
	],
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #adding }
GQLSInterfaceTypeNode >> addFields: aArray [
"Puts the fields of the array on a dictionary"
	aArray do: [ :field | fields at: field name put: field ]
]

{ #category : #accessing }
GQLSInterfaceTypeNode >> fields [
"Return the fields"
	^ fields
]

{ #category : #'as yet unclassified' }
GQLSInterfaceTypeNode >> fieldsIncludeDeprecated: aBoolean [
	^ self fields
]

{ #category : #accessing }
GQLSInterfaceTypeNode >> getField: aFieldName [
	"Return the field given his name"

	| res |
	res := (fields includesKey: aFieldName)
		ifTrue: [ fields at: aFieldName ]
		ifFalse: [ nil ].
	^ res
]

{ #category : #accessing }
GQLSInterfaceTypeNode >> implementors [ 
	^ implementors 
]

{ #category : #accessing }
GQLSInterfaceTypeNode >> implementors: anArray [
	implementors := anArray
]

{ #category : #initialization }
GQLSInterfaceTypeNode >> initialize [
	super initialize.
	fields := Dictionary new
]

{ #category : #testing }
GQLSInterfaceTypeNode >> isInterfaceType [
"Return if is a interface type"
	^ true
]

{ #category : #accessing }
GQLSInterfaceTypeNode >> kind [
	^ 'INTERFACE'
]

{ #category : #'as yet unclassified' }
GQLSInterfaceTypeNode >> possibleTypes [
	^ self implementors 
]

{ #category : #printing }
GQLSInterfaceTypeNode >> printFullOn: stream [
	stream 
		nextPutAll: 'interface ';
		nextPutAll: self name.
	stream nextPutAll: '{'; cr.
	self fields 
		do: [ :field | 
			stream tab.
			field printFullOn: stream ] 
		separatedBy: [ stream cr ].
	stream cr; nextPutAll: '}'
]

{ #category : #'as yet unclassified' }
GQLSInterfaceTypeNode >> verifyAndInclude: otherNamedType  with: resolvers [
	(otherNamedType class = self class and: 
	[ (fields keys includesAny: otherNamedType fields keys) not ])
	ifTrue: [ fields addAll: otherNamedType fields ]
	ifFalse: [ ^ GQLValidationException new node: otherNamedType;
					messageText: 'The namedType is not Interface type or its fields already have been defined'; raise  ]
]
