"
I represent a non scalar field ""__schema: __Schema!!"". This means that I have a selectionSet. For example

__schema{
	queryType { name }
}

"
Class {
	#name : #GQLSchemaFieldNode,
	#superclass : #GQLNonScalarFieldNode,
	#classInstVars : [
		'dictNameMetaSchema'
	],
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #accessing }
GQLSchemaFieldNode class >> dictNameMetaSchema [
	dictNameMetaSchema ifNil: [
		dictNameMetaSchema := Dictionary new 
		at: 'GQLSSchemaNode' put: '__Schema';
		at: 'GQLSTypeNode' put: '__Type';
		at: 'GQLSFieldNode' put: '__Field';
		at: 'GQLSEnumValue' put: '__EnumValue';
		at: 'GQLSInputObjectFieldNode' put: '__InputValue';
		at: 'GQLSDirectiveNode' put: '__Directive';
		at: 'GQLSStringTypeNode' put: 'String';
		at: 'GQLSBooleanTypeNode' put: 'Boolean';
		yourself. 
	].
	^ dictNameMetaSchema
]

{ #category : #visiting }
GQLSchemaFieldNode >> accept: visitor [
	visitor visitSchemaFieldNode: self.
]

{ #category : #action }
GQLSchemaFieldNode >> executeOn: resolver with: context using: schema [
	| objectValue result |
	objectValue := GQLSSchemaNode new.
	result := self selectionSet executeOn: objectValue with: context using: schema. 
	result at: 'types' 
	ifPresent: [ :list | list do: [ :dict |
		dict at: 'name'
		ifPresent: [ :aName | 
			self class dictNameMetaSchema at: aName 
			ifPresent: [ :val | dict at: 'name' put: val ] ] 
	] ].
	^ result
]

{ #category : #accessing }
GQLSchemaFieldNode >> targetSpreads [
"Return the fragments spreads used on the selectionSet"
	^ #()
]
