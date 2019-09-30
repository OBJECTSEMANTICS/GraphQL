"
I represent a non scalar field. This means that I have a selectionSet. For example

fieldNonScalar{
	fieldScalar
}

Public API and Key Messages

- isScalar
- selectionSet

    Instance Variables
	selectionSet:		<GQLSelectionSetNode>


    Implementation Points
"
Class {
	#name : #GQLNonScalarFieldNode,
	#superclass : #GQLFieldNode,
	#instVars : [
		'selectionSet'
	],
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #visiting }
GQLNonScalarFieldNode >> accept: visitor [
	visitor visitNonScalarFieldNode: self
]

{ #category : #utils }
GQLNonScalarFieldNode >> collectVariablesOn: context with: visitedFragments [
	| groupVariables args |
	groupVariables := Set new.
	args := self collectAllArguments.
	groupVariables addAll: (self collectVariables: args using: context).
	selectionSet ifNotNil: [ 
		groupVariables addAll: (self collectVarSelectionSet: selectionSet using: context with: visitedFragments)].
	^ groupVariables.
]

{ #category : #action }
GQLNonScalarFieldNode >> executeOn: resolver with: context using: schema [
"Given a resolver, an contextiroment and the schema, execute the request"
	| objectValue type result params className field resolverSel |
	className := resolver isClass
		ifTrue: [ #Class ]
		ifFalse: [ resolver className ].
	params := self paramsOn: resolver with: context using: schema ofClass: className.
	field := self fieldOfType: className using: schema.
	type := field type.
	(type class = GQLSNonNullTypeNode ) ifTrue: [ type := type wrappedType ].
	resolverSel := resolver.
	(resolver class = schema class) 
	ifTrue: [ resolverSel := schema ].
	objectValue := self valueOf: resolverSel toPerform: field with: params using: schema.
	type class = GQLSListTypeNode
		ifTrue: [ result := OrderedCollection new.
			objectValue ifNotNil: [ 
				objectValue
					do: [ :el | 
					result add: (self selectionSet executeOn: el with: context using: schema) ]
			] ifNil: [ result := nil ] ]
		ifFalse: [ result := self selectionSet executeOn: objectValue with: context using: schema ].
	^ result
]

{ #category : #testing }
GQLNonScalarFieldNode >> isScalar [
"Answer false because is not scalar"
	^ false
]

{ #category : #accessing }
GQLNonScalarFieldNode >> selectionSet [
"Return the selection set"
	^ selectionSet
]

{ #category : #accessing }
GQLNonScalarFieldNode >> selectionSet: anObject [
"Set the selection set"
	selectionSet := anObject
]

{ #category : #accessing }
GQLNonScalarFieldNode >> targetSpreads [
"Return the fragments spreads used on the selectionSet"
	^ selectionSet targetSpreads
]
