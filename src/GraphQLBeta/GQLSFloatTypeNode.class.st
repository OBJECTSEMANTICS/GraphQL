"
I represent a Float type.
"
Class {
	#name : #GQLSFloatTypeNode,
	#superclass : #GQLSScalarTypeNode,
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #testing }
GQLSFloatTypeNode >> basicCoerce: value on: schema [
	^ value class = GQLFloatNode or: [ value class = GQLIntNode ]
]

{ #category : #coercion }
GQLSFloatTypeNode >> coerceValue: value on: schema [
	value isVariableNode ifTrue: [ ^ value ].
	value class = GQLNullNode ifTrue: [ ^ value ].
	(self canCoerce: value on: schema) ifFalse: [ self error: 'invalid input' ].
	value class = GQLIntNode ifTrue: [ 
		^ GQLFloatNode new
			value: value value, '.0';
			position: value position.
		 ].
	^ value
]

{ #category : #initialization }
GQLSFloatTypeNode >> initialize [
	super initialize.
	name := 'Float'
]
