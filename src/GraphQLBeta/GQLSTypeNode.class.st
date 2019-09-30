"
I represent a type node.

For more information see my subclasses
"
Class {
	#name : #GQLSTypeNode,
	#superclass : #GQLSNode,
	#instVars : [
		'name'
	],
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #testing }
GQLSTypeNode >> basicCoerce: value on: schema [
	self subclassResponsibility.
]

{ #category : #testing }
GQLSTypeNode >> canCoerce: value on: schema [
	^ value class = GQLNullNode 
		ifTrue: [ true ]
		ifFalse: [ self basicCoerce: value on: schema ]
]

{ #category : #coercion }
GQLSTypeNode >> coerceValue: value on: schema [
	value isVariableNode ifTrue: [ ^ value ].
	(self canCoerce: value on: schema) ifFalse: [ self error: 'invalid input' ].
	^ value
]

{ #category : #accessing }
GQLSTypeNode >> description [
	^ super description value
]

{ #category : #'as yet unclassified' }
GQLSTypeNode >> enumValuesIncludeDeprecated: aBoolean [
	^ nil
]

{ #category : #'as yet unclassified' }
GQLSTypeNode >> fieldOfName: aString using: aSchema [
	^ (aSchema getType: GQLSTypeNode new className) getField: aString
]

{ #category : #'as yet unclassified' }
GQLSTypeNode >> fieldsIncludeDeprecated: aBoolean [
	^ nil
]

{ #category : #accessing }
GQLSTypeNode >> getField: string [
	^ nil
]

{ #category : #'as yet unclassified' }
GQLSTypeNode >> inputFields [
	^ nil
]

{ #category : #accessing }
GQLSTypeNode >> interfaces [
	^ nil 
]

{ #category : #testing }
GQLSTypeNode >> isInputType [
"Return if is a input type"
	^ false
]

{ #category : #testing }
GQLSTypeNode >> isInterfaceType [
"Return if is a interface type"
	^ false
]

{ #category : #testing }
GQLSTypeNode >> isObjectInputType: schema [
	^ false
]

{ #category : #testing }
GQLSTypeNode >> isObjectType [
"Return if is a object type"
	^ false
]

{ #category : #testing }
GQLSTypeNode >> isScalarType [
"Return if is a scalar type"
	^ false
]

{ #category : #testing }
GQLSTypeNode >> isTypeNode [
	^ true
]

{ #category : #testing }
GQLSTypeNode >> isUnionType [
"Return if is a union type"
	^ false
]

{ #category : #testing }
GQLSTypeNode >> isValidateClass [
"Respondes if a type needs to be searched on the image of Pharo"

	^ false
]

{ #category : #testing }
GQLSTypeNode >> isWrappedType [
"Return if is a wrapped type"
	^ false
]

{ #category : #accessing }
GQLSTypeNode >> kind [
	^ self subclassResponsibility 
]

{ #category : #accessing }
GQLSTypeNode >> name [
	^ name
]

{ #category : #accessing }
GQLSTypeNode >> name: aString [
	name := aString
]

{ #category : #'as yet unclassified' }
GQLSTypeNode >> ofType [
	^ self subclassResponsibility 
]

{ #category : #accessing }
GQLSTypeNode >> possibleTypes [
	^ nil
]
