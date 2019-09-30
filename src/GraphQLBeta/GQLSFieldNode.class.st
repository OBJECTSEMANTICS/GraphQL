"
I represent a field node, I'm present on object and interface types.

Public API and Key Messages

- addArguments: 
- arguments
- arguments: 
- fullName 
- getArgument: 
- name
- name: 
- type
- type:

    Instance Variables
	arguments:		<Dictionary>
	fullName:		<String>
	name:		<String>
	type:		<GQLSTypeNode>

"
Class {
	#name : #GQLSFieldNode,
	#superclass : #GQLSNode,
	#instVars : [
		'name',
		'type',
		'arguments',
		'fullName'
	],
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #adding }
GQLSFieldNode >> addArguments: aArray [
"Given a collection puts the values on a dictionary for improve the search"
	aArray
		ifNotNil: [ :array | array do: [ :argument | arguments at: argument name put: argument ] ]
]

{ #category : #accessing }
GQLSFieldNode >> args [ 
	^ arguments values
]

{ #category : #accessing }
GQLSFieldNode >> arguments [
"Return the arguments"
	^ arguments
]

{ #category : #'as yet unclassified' }
GQLSFieldNode >> deprecationReason [
	^ nil
]

{ #category : #accessing }
GQLSFieldNode >> fullName [
	"Return the full name"

	fullName
		ifNil: [ | write |
			write := WriteStream on: String new.
			write nextPutAll: self name.
			self arguments
				ifNotEmpty: [ :ags | 
					ags keys
						doWithIndex: [ :na :i | 
							i = 1
								ifTrue: [ write
										nextPutAll: na capitalized;
										nextPut: $: ]
								ifFalse: [ write
										nextPutAll: na;
										nextPut: $: ] ] ].
			fullName := write contents ].
	^ fullName
]

{ #category : #accessing }
GQLSFieldNode >> getArgument: aString [
	"Return a argument given his name"

	(arguments includesKey: aString)
		ifTrue: [ ^ arguments at: aString ].
	^ nil
]

{ #category : #initialization }
GQLSFieldNode >> initialize [
	super initialize.
	description := GQLSDescription new.
	arguments := OrderedDictionary new
]

{ #category : #testing }
GQLSFieldNode >> isDeprecated [
	^ false
]

{ #category : #accessing }
GQLSFieldNode >> name [
"Return the name"
	^ name
]

{ #category : #accessing }
GQLSFieldNode >> name: aName [
"Set the name"

	name := aName
]

{ #category : #printing }
GQLSFieldNode >> printFullOn: stream [
	stream nextPutAll: self name.
	self arguments ifNotEmpty: [ 
		stream nextPutAll: '('.
		self arguments
			do: [ :arg | arg printFullOn: stream ]
			separatedBy: [ stream nextPutAll: ', ' ].
		stream nextPutAll: ')' ].
	stream nextPutAll: ': '.
	self type printOn: stream.
]

{ #category : #accessing }
GQLSFieldNode >> type [
"Return the type"
	^ type
]

{ #category : #accessing }
GQLSFieldNode >> type: aType [
"Set the type"

	type := aType
]
