"
I represent a scalar field on a request.

Public API and Key Messages

- isScalar

"
Class {
	#name : #GQLScalarFieldNode,
	#superclass : #GQLFieldNode,
	#classInstVars : [
		'dictTypeName'
	],
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #accessing }
GQLScalarFieldNode class >> dictTypeName [
	dictTypeName ifNil: [ 
		dictTypeName := Dictionary new 
		at: 'GQLSTypeNode' put: '__Type';
		at: 'GQLSInputObjectFieldNode' put: '__InputValue';
		at: 'GQLSFieldNode' put: '__Field';
		at: 'GQLSEnumValue' put: '__EnumValue';
		at: 'GQLSDirectiveNode' put: '__Directive';
		yourself
	].
	^ dictTypeName
]

{ #category : #visiting }
GQLScalarFieldNode >> accept: visitor [
	visitor visitScalarFieldNode: self
]

{ #category : #action }
GQLScalarFieldNode >> executeOn: resolver with: context using: schema [
"Given a resolver, an enviroment and the schema, execute the scalar node"
	| result params className selector resolverSelector field dict |
	selector := self fullName asSymbol.
	resolverSelector := resolver.
	className := resolverSelector isClass
		ifTrue: [ #Class ]
		ifFalse: [ resolverSelector className ].
	params := self paramsOn: resolverSelector with: context using: schema ofClass: className.
	field := ((schema getType: className) getField: self name).
	field ifNotNil: [ selector := field fullName asSymbol ].
	resolverSelector class allMethods detect: [:method | method selector = selector]
	ifNone: [ resolverSelector := (schema dictFieldsResolvers at: selector) new ].
	result := resolverSelector
		perform: selector
		withArguments: params asArray.
	dict := self class dictTypeName.
	(dict keys includes: result) ifTrue: [ result := dict at: result  ].
	^ result
]

{ #category : #testing }
GQLScalarFieldNode >> isScalar [
"Answer true for be a scalar field"
	^ true
]

{ #category : #accessing }
GQLScalarFieldNode >> targetSpreads [
"Return empty beacuse cant have fragment spreads"
	^ #()
]
