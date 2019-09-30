"
I represent a enum type. I have several values.

Public API and Key Messages

- addValues:
- values

    Instance Variables
	stringValues:		<Array>


    Implementation Points
"
Class {
	#name : #GQLSEnumTypeNode,
	#superclass : #GQLSNamedTypeNode,
	#instVars : [
		'enumValues'
	],
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #adding }
GQLSEnumTypeNode >> addValues: values [
"Set the string of values "
	enumValues := values
]

{ #category : #testing }
GQLSEnumTypeNode >> basicCoerce: value on: schema [
	^ value class = GQLEnumNode and: [ 
		self stringValues includes: value value ].
]

{ #category : #'as yet unclassified' }
GQLSEnumTypeNode >> enumValuesIncludeDeprecated: aBoolean [
	^ enumValues
]

{ #category : #testing }
GQLSEnumTypeNode >> isInputType [
"Return if is input type"
	^ true
]

{ #category : #testing }
GQLSEnumTypeNode >> isScalarType [ 
	^ true
]

{ #category : #accessing }
GQLSEnumTypeNode >> kind [
	^ 'ENUM'
]

{ #category : #accessing }
GQLSEnumTypeNode >> nameOfClass: aName [
	^ self class name
]

{ #category : #printing }
GQLSEnumTypeNode >> printFullOn: stream [
	stream 
		nextPutAll: 'enum ';
		nextPutAll: self name;
		nextPutAll: '{ '.
	self stringValues
		do: [ :v | stream nextPutAll: v ]
		separatedBy: [ stream nextPutAll: ', ' ].
	stream nextPutAll: ' }'.
]

{ #category : #accessing }
GQLSEnumTypeNode >> stringValues [
	^ enumValues collect: [ :val | val value ].
]

{ #category : #accessing }
GQLSEnumTypeNode >> values [
"Return the string values"
	^ enumValues
]

{ #category : #'as yet unclassified' }
GQLSEnumTypeNode >> verifyAndInclude: otherNamedType  with: resolvers [
	(otherNamedType class = self class and: 
	[ (enumValues includesAny: otherNamedType values) not ])
	ifTrue: [ enumValues := (OrderedCollection new addAll: enumValues ; addAll:otherNamedType values; yourself) asArray ]
	ifFalse: [ ^ GQLValidationException new node: otherNamedType;
													messageText: 'The namedType is not Enum type or its values already have been defined'; raise  ]
]
