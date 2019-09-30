"
I am a validator, based on https://github.com/graphql/graphql-js/tree/master/src/validation
"
Class {
	#name : #GQLValidator,
	#superclass : #GraphQLObject,
	#instVars : [
		'document',
		'text',
		'schema',
		'visitors',
		'shouldValidate',
		'rootInstance',
		'context',
		'operationName',
		'variables'
	],
	#category : #'GraphQLBeta-Validation'
}

{ #category : #accessing }
GQLValidator >> document: doc [
	document := doc
]

{ #category : #public }
GQLValidator >> execute [
	| errors |
	context := GQLContext new 
		addFragments: document fragments;
		operationName: operationName;
		variables: variables.
	shouldValidate ifFalse: [ ^ self executeDocument ].
	errors := self validate.
	^ errors 
		ifEmpty: [ self executeDocument ]
		ifNotEmpty: [ ^ Dictionary new 
			at: 'errors' put: errors;
			yourself ].
]

{ #category : #public }
GQLValidator >> executeDocument [
	
	^ document
		executeOn: rootInstance
		with: context
		using: schema.
]

{ #category : #initialization }
GQLValidator >> initialize [
	super initialize.
	self shouldValidate: true.
	visitors := OrderedCollection new
		add: GQLFragmentsVisitor new;"first to indetify the recursive fragments"
		add: GQLOperationsVisitor new;
		add: GQLFieldsVisitor new;
		add: GQLArgumentsVisitor new;
		add: GQLValuesVisitor new;
		add: GQLDirectivesVisitor new;
		add: GQLVariablesVisitor new;
		yourself.
]

{ #category : #accessing }
GQLValidator >> operationName: string [
	operationName := string
]

{ #category : #accessing }
GQLValidator >> rootInstance [
	^ rootInstance
]

{ #category : #accessing }
GQLValidator >> rootInstance: anObject [
	rootInstance := anObject
]

{ #category : #accessing }
GQLValidator >> schema: sc [
	schema := sc.
]

{ #category : #accessing }
GQLValidator >> shouldValidate [
	^ shouldValidate 
]

{ #category : #accessing }
GQLValidator >> shouldValidate: bool [
	shouldValidate := bool.
]

{ #category : #accessing }
GQLValidator >> text: string [
	text := string
]

{ #category : #public }
GQLValidator >> validate [
	| errors locationBlock |
	errors := OrderedCollection new.
	self shouldValidate ifFalse: [ ^ errors ].
	visitors do: [ :visitor |
		visitor 
			text: text;
			schema: schema;
			context: context;
			errors: OrderedCollection new.
		document accept: visitor.
		errors addAll: visitor errors.
		 ].
	locationBlock := [:a :b | a line = b line "a and b are GQLPosition"
		ifTrue: [ a column < b column ]
		ifFalse: [ a line < b line ] ].
	errors copy do: [ :error | 
		| repitedErrors sortedLocations |
		repitedErrors := errors select: [ :e | e message = error message ].
		repitedErrors size > 1 ifTrue: [ 
			2 to: repitedErrors size do: [ :index | | e |
				e := repitedErrors at: index.
				errors remove: e.
				error addLocations: e locations. ].
			sortedLocations := error locations asSet asOrderedCollection.
			sortedLocations sort: locationBlock .
			error locations: sortedLocations 
			 ] ].
	errors sort: [ :a :b | locationBlock
		value: a locations first
		value: b locations first ].
	^ errors
	



]

{ #category : #accessing }
GQLValidator >> variables: vars [
	variables := vars
]
