"
I represent a field on a request.

Public API and Key Messages

- alias
- arguments
- fullName
- isScalar
- name

    Instance Variables
	alias:		<String>
	arguments:		<Array>
	fullName:		<String>
	name:		<String>


    Implementation Points
"
Class {
	#name : #GQLFieldNode,
	#superclass : #GQLSelectionNode,
	#instVars : [
		'alias',
		'name',
		'arguments',
		'fullName'
	],
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #accessing }
GQLFieldNode >> alias [
"Return the alias"
	^ alias
]

{ #category : #accessing }
GQLFieldNode >> alias: anObject [
"Set the alias"
	alias := anObject
]

{ #category : #accessing }
GQLFieldNode >> arguments [
"Return the arguments"
	^ arguments
]

{ #category : #accessing }
GQLFieldNode >> arguments: anObject [
"If anObject is nil set the arguments to a new array, otherwise set the arguments"
	anObject ifNil: [ arguments := Array new ]
				ifNotNil: [ arguments := anObject ] 
]

{ #category : #'as yet unclassified' }
GQLFieldNode >> collectAllArguments [
	| args |
	args := OrderedCollection new.
	self directives do: [ :d|
		args addAll: d arguments ].
	args addAll: arguments.
	^ args
]

{ #category : #'as yet unclassified' }
GQLFieldNode >> collectVariables: args using: context [
	| groupedVariables |
	groupedVariables := Set new.
	args collect: [ :arg | arg value valueVariables ]
	thenDo: [ :dictVariables | 
		dictVariables keys do: [ :keyVariable | 
			context variables at: keyVariable
			ifAbsent: [ context variables at: keyVariable put: (GQLVariableDefinitionNode new name: (dictVariables at: keyVariable))].
			groupedVariables add: keyVariable
		].
	].
	^ groupedVariables 
]

{ #category : #'as yet unclassified' }
GQLFieldNode >> collectVariablesOn: context with: visitedFragments [
	| args groupedVariables |
	groupedVariables := Set new.
	args := self collectAllArguments.
	groupedVariables := self collectVariables: args using: context.
	^ groupedVariables 
]

{ #category : #action }
GQLFieldNode >> executeOn: resolver with: context using: schema [

	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
GQLFieldNode >> fieldOfType: aString using: aSchema [
	| type field |
	type := aSchema getType: aString.
	field := type getField: self name.
	field ifNil: [ field := type fieldOfName: self name using: aSchema ].
	^ field
]

{ #category : #accessing }
GQLFieldNode >> fullName [
	"Return the full name"

	fullName
		ifNil: [ | write |
			write := WriteStream on: String new.
			write nextPutAll: self name.
			self arguments
				ifNotEmpty: [ :ags | 
					ags doWithIndex: [ :ag :i | 
							i = 1
								ifTrue: [ write
										nextPutAll: ag name capitalized;
										nextPut: $: ]
								ifFalse: [ write
										nextPutAll: ag name;
										nextPut: $: ] ] ].
			fullName := write contents ].
	^ fullName
]

{ #category : #testing }
GQLFieldNode >> hasSameArguments: args [
	^ arguments size = args size and: [ 
		arguments allSatisfy: [ :arg | 
			args anySatisfy: [ :a | arg name = a name and: [ arg value = a value ] ] ] ]
]

{ #category : #utils }
GQLFieldNode >> ifField: aFieldBlock ifFragment: aFragmentBlock ifInline: aInlineBlock [

	^ aFieldBlock value
]

{ #category : #testing }
GQLFieldNode >> isScalar [
"To verify if a field is scalar"
	self shouldBeImplemented
]

{ #category : #accessing }
GQLFieldNode >> key [
"The key on the dictionary of the response"
	^ alias ifNil: [ name ] ifNotNil: [ alias ]
]

{ #category : #accessing }
GQLFieldNode >> name [
"Return the name"
	^ name
]

{ #category : #accessing }
GQLFieldNode >> name: anObject [
"Set the name"
	name := anObject
]

{ #category : #accessing }
GQLFieldNode >> paramsOn: resolver with: context using: schema ofClass: className [
	| params field |
	field := self fieldOfType: className using: schema.
	params := field arguments
		collect: [ :argS | 
			| arg |
			arg := self arguments detect: [ :a | a name = argS name ] 
				ifFound: [ :a | a ] 
				ifNone: [ nil ].
			arg ifNotNil: [ | resolverArg |
				resolverArg := arg
					resolverArg: resolver
					with: field
					ofType: argS type
					using: schema.
				arg value: (argS type coerceValue: arg value on: schema).
				arg executeOn: resolverArg with: context using: schema
			].
		].
	^ params
]

{ #category : #accessing }
GQLFieldNode >> targetSpreads [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GQLFieldNode >> valueOf: resolver toPerform: field with: aArray using: aSchema [
	| block response |
	block := [ :aResolver :aField :array | 
		aResolver perform: aField fullName asSymbol 
		withArguments: array asArray
	].
	[ response := block valueWithArguments: { resolver. field. aArray } ] on: Error do: [ :ex |
		response := block valueWithArguments: { (aSchema getType: resolver className). field. aArray }.
		].
	^ response
]
