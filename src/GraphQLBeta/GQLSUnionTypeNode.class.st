"
I represent a union type and i have types.

Public API and Key Messages

- addTypes:
- namedTypes

    Instance Variables
	namedTypes:		<Dictionary>

"
Class {
	#name : #GQLSUnionTypeNode,
	#superclass : #GQLSNamedTypeNode,
	#instVars : [
		'namedTypes',
		'possibleTypes'
	],
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #accessing }
GQLSUnionTypeNode >> addPossibleType: anObject [
	possibleTypes add: anObject
]

{ #category : #adding }
GQLSUnionTypeNode >> addTypes: nameValues [
"Given a collection puts the values on a dictionary for improve the search"

	namedTypes := nameValues
]

{ #category : #accessing }
GQLSUnionTypeNode >> getField: fieldName [
	^ fieldName = '__typename'
		ifTrue: [ GQLSFieldNode new 
			name: '__typename';
			type: GQLSStringTypeNode new;
			fullName;
			yourself ]
		ifFalse: [  ]
]

{ #category : #initialization }
GQLSUnionTypeNode >> initialize [ 
	super initialize.
	possibleTypes := OrderedCollection new.
]

{ #category : #testing }
GQLSUnionTypeNode >> isUnionType [
"Return if is a union type"
	^ true
]

{ #category : #accessing }
GQLSUnionTypeNode >> kind [
	^ 'UNION'
]

{ #category : #accessing }
GQLSUnionTypeNode >> namedTypes [
"Return the named types"
	^ namedTypes
]

{ #category : #accessing }
GQLSUnionTypeNode >> possibleTypes [
	^ possibleTypes 
]

{ #category : #printing }
GQLSUnionTypeNode >> printFullOn: stream [
	stream
		nextPutAll: 'union ';
		nextPutAll: self name;
		nextPutAll: ' = '.
	self namedTypes
	 	do: [ :n | stream nextPutAll: n ]
		separatedBy: [ stream nextPutAll: ' | ' ]
]

{ #category : #'as yet unclassified' }
GQLSUnionTypeNode >> verifyAndInclude: otherNamedType  with: resolvers [
	(otherNamedType class = self class and: 
	[ (namedTypes includesAny: otherNamedType namedTypes) not ])
	ifTrue: [ namedTypes := (OrderedCollection new addAll: namedTypes; addAll: otherNamedType namedTypes; yourself) asArray ]
	ifFalse: [ ^ GQLValidationException new node: otherNamedType;
					messageText: 'The namedType is not Union type or its values already have been defined'; raise  ]
]
