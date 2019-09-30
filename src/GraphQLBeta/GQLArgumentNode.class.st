"
I represent an argument on the request.

Public API and Key Messages

- name
- name:
- value
- value:
- executeOn:with:using:

    Instance Variables
	name:		<String>
	value:		<GQLValueNode>

"
Class {
	#name : #GQLArgumentNode,
	#superclass : #GQLNode,
	#instVars : [
		'name',
		'value'
	],
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #comparing }
GQLArgumentNode >> = another [
	^ (name = another name) and: [ value = another value ]
]

{ #category : #visiting }
GQLArgumentNode >> accept: visitor [
	visitor visitArgumentNode: self
]

{ #category : #action }
GQLArgumentNode >> executeOn: resolver with: context using: schema [
"Pass to execute the argument value"
	^ value
		executeOn: resolver
		with: context
		using: schema
]

{ #category : #accessing }
GQLArgumentNode >> name [
"Return the name"
	^ name
]

{ #category : #accessing }
GQLArgumentNode >> name: anObject [
"Set the name"
	name := anObject
]

{ #category : #comparing }
GQLArgumentNode >> partialEquals: other using: context [
"Given other argument, verify if have the same name and return the same type of value"
	^ (self name = other name) and: [ | type |
		type := other type wrappedType name.
		self value class = GQLVariableNode
			ifTrue: [
				 other type asString beginsWith: (context variables at: self value value ) type asString]
			ifFalse: [ self value nodeName = type ].
		
	]
]

{ #category : #printing }
GQLArgumentNode >> printValueOn: stream [
	self value printOn: stream.
]

{ #category : #accessing }
GQLArgumentNode >> resolver: aType using: schema [
	| symbol cls |
	symbol := self value name: aType name using: schema.
	symbol ifNil: [ ^ nil ].
	symbol := symbol asSymbol.
	cls := Smalltalk classNamed: symbol.
	cls ifNil: [ self error: 'Missing class' ].
	^ cls new
]

{ #category : #accessing }
GQLArgumentNode >> resolverArg: resolver with: field ofType: aType [
	| resolverArg |
	aType isScalarType 
	ifTrue: [ ^ resolver ] 
	ifFalse: [ aType isWrappedType 
		ifTrue: [ resolverArg := (self resolverArg: resolver with: field ofType: aType wrappedType) ]
		ifFalse: [ | nameResolver allClasses class |
			nameResolver := (aType nameUsing: self value) asSymbol .
			allClasses := Smalltalk allClasses.
			class := allClasses 
				detect: [ :c | c name = nameResolver ] 
				ifNone: [ self error: 'not valid' ].
			resolverArg := class new.
			]
		 ].
	^ resolverArg
]

{ #category : #accessing }
GQLArgumentNode >> resolverArg: resolver with: field ofType: aType using: schema [
	aType isScalarType 
	ifTrue: [ ^ resolver ] 
	ifFalse: [ 
		aType isWrappedType 
		ifTrue: [ ^ self resolverArg: resolver with: field ofType: aType wrappedType using: schema ]
		ifFalse: [ ^ self resolver: aType using: schema ].
	].
]

{ #category : #accessing }
GQLArgumentNode >> value [
"Return the value"
	^ value
]

{ #category : #accessing }
GQLArgumentNode >> value: anObject [
"Set the value"
	value := anObject
]
