"
I represent a non scalar field ""__type(name: String!): __Type"". This means that I have a selectionSet. For example

__type(name: ""FooType""){
	name
}

"
Class {
	#name : #GQLTypeFieldNode,
	#superclass : #GQLNonScalarFieldNode,
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #visiting }
GQLTypeFieldNode >> accept: visitor [
	visitor visitTypeFieldNode: self.
]

{ #category : #action }
GQLTypeFieldNode >> executeOn: resolver with: context using: schema [
	| param className newResolver |
	className := resolver className.
	param := (self paramsOn: resolver with: context using: schema ofClass: className) first.
	newResolver := schema schemaTypes at: param 
	ifAbsent: [ GQLSSchemaNode dictNameTypesMetaSchema at: param 
		ifPresent: [ :value | newResolver := schema schemaTypes at: value ]
		ifAbsent: [ ^ nil ] 
	].
	^ self selectionSet executeOn: newResolver with: context using: schema.
]

{ #category : #accessing }
GQLTypeFieldNode >> paramsOn: resolver with: context using: schema ofClass: className [
	| params |
	params := OrderedCollection new.
	(arguments size = 1 and: [ arguments first name = 'name' ])
	ifTrue: [ | argument |
		argument := arguments first.	
		params add: (argument executeOn: resolver with: context using: schema)
	].
	^ params
]

{ #category : #accessing }
GQLTypeFieldNode >> targetSpreads [
"Return the fragments spreads used on the selectionSet"
	^ selectionSet targetSpreads
]
